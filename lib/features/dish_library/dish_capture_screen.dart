import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/providers.dart';
import '../../data/repositories/dish_repository.dart';
import '../../data/remote/nutrition_lookup_service.dart';
import '../../data/remote/vision_ai_service.dart';

class DishCaptureScreen extends ConsumerStatefulWidget {
  const DishCaptureScreen({super.key});

  @override
  ConsumerState<DishCaptureScreen> createState() => _DishCaptureScreenState();
}

class _DishCaptureScreenState extends ConsumerState<DishCaptureScreen> {
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _ingredientController = TextEditingController();
  XFile? _photo;
  RecognizedDish? _recognized;
  List<String> _editableIngredients = [];
  String? _recognitionMessage;
  Future<void> Function()? _retryAction;
  bool _busy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    final photo = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1280,
      maxHeight: 1280,
    );
    if (photo == null) return;
    setState(() {
      _photo = photo;
      _recognized = null;
      _editableIngredients = [];
      _recognitionMessage = null;
    });
    await _recognize(photo);
  }

  Future<void> _recognize(XFile photo) async {
    setState(() => _busy = true);
    try {
      final result = await ref
          .read(visionAiServiceProvider)
          .recognizeIngredients(photo.path);
      if (result.ingredients.isEmpty) {
        throw StateError('Gemini returned no ingredients.');
      }
      if (!mounted) return;
      setState(() {
        _recognized = result;
        _editableIngredients = [...result.ingredients];
        _nameController.text = result.mealName ?? _nameFromPath(photo.path);
        _recognitionMessage = null;
        _retryAction = () => _recognize(photo);
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _recognized = null;
          _recognitionMessage = _recognitionErrorMessage(error);
          _retryAction = () => _recognize(photo);
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _recognitionErrorMessage(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 401) return 'Your session expired. Sign in again.';
      if (status == 422) {
        return 'Gemini could not identify a usable dish. Try a clearer image.';
      }
      if (status != null && status >= 500) {
        return 'Gemini recognition is temporarily unavailable. Try again shortly.';
      }
      return 'Could not reach Gemini recognition. Check your connection and retry.';
    }
    if (error is StateError) return error.message.toString();
    return 'Could not recognize that image. Try again.';
  }

  Future<void> _save() async {
    final profile = ref.read(currentProfileProvider).value;
    final recognized = _recognized;
    final price = double.tryParse(_priceController.text);
    if (profile == null || recognized == null || price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Choose a photo, review the ingredients, and add a valid price.',
          ),
        ),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final nutrition = ref.read(nutritionLookupServiceProvider);
      final drafts = <IngredientDraft>[];
      var lookupFailed = false;
      for (final name in _editableIngredients) {
        NutritionProfile? profile;
        try {
          profile = await nutrition.lookup(name);
        } catch (_) {
          lookupFailed = true;
        }
        drafts.add(
          IngredientDraft(
            name: name,
            calories: profile?.calories ?? 0,
            proteinG: profile?.proteinG ?? 0,
            carbsG: profile?.carbsG ?? 0,
            fatG: profile?.fatG ?? 0,
          ),
        );
      }
      await ref
          .read(dishRepositoryProvider)
          .createDish(
            profileId: profile.id,
            name: _nameController.text.trim().isEmpty
                ? 'Captured dish'
                : _nameController.text.trim(),
            priceCents: (price * 100).round(),
            cuisineTag: recognized.cuisine,
            source: 'ai',
            photoPath: _photo?.path,
            ingredients: drafts,
          );
      if (mounted) {
        if (lookupFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dish saved. Some nutrition data is pending.'),
            ),
          );
        }
        context.go('/home');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save this dish. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _scanReceipt() async {
    final photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (photo == null) return;
    await _scanReceiptPhoto(photo);
  }

  Future<void> _scanReceiptPhoto(XFile photo) async {
    setState(() {
      _photo = photo;
      _recognized = null;
      _recognitionMessage = null;
      _busy = true;
    });
    try {
      final result = await ref
          .read(visionAiServiceProvider)
          .recognizeIngredients(photo.path);
      final ingredients = result.ingredients;
      if (!mounted) return;
      setState(() {
        _recognized = RecognizedDish(
          ingredients: ingredients,
          mealName: result.mealName ?? 'Scanned menu dish',
          cuisine: result.cuisine ?? 'Scanned menu',
        );
        _editableIngredients = [...ingredients];
        _nameController.text = result.mealName ?? 'Scanned menu dish';
        _recognitionMessage = null;
        _retryAction = () => _scanReceiptPhoto(photo);
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not read that image. Try a clearer photo.'),
          ),
        );
        setState(() {
          _recognitionMessage = 'Could not read that image. Try again.';
          _retryAction = () => _scanReceiptPhoto(photo);
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _nameFromPath(String path) {
    final name = path
        .split(Platform.pathSeparator)
        .last
        .split('.')
        .first
        .replaceAll(RegExp(r'[-_]'), ' ');
    return name.isEmpty ? 'Captured dish' : name;
  }

  void _addIngredient() {
    final ingredient = _ingredientController.text.trim().toLowerCase();
    if (ingredient.isEmpty || _editableIngredients.contains(ingredient)) return;
    setState(() {
      _editableIngredients = [..._editableIngredients, ingredient];
      _ingredientController.clear();
    });
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _editableIngredients = _editableIngredients
          .where((item) => item != ingredient)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recognized = _recognized;
    return Scaffold(
      appBar: AppBar(title: const Text('Capture a dish')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          Text(
            'Photo to ingredients',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Recognition uses secure cloud AI. Review the results before saving.',
          ),
          const SizedBox(height: 20),
          if (_photo != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_photo!.path),
                height: 180,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 180,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.photo_camera_outlined, size: 52),
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Camera'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Gallery'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _busy ? null : _scanReceipt,
            icon: const Icon(Icons.document_scanner_outlined),
            label: const Text('Scan a printed menu or receipt'),
          ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_recognitionMessage != null)
            Card(
              color: const Color(0xFFFFF4DD),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_recognitionMessage!)),
                    TextButton(
                      onPressed: _busy ? null : _retryAction,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          if (recognized != null) ...[
            const SizedBox(height: 18),
            Text(
              'Review recognition',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Dish name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price per serving',
                prefixText: '${ref.watch(currencyProvider).symbol} ',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Correct the results before saving',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _editableIngredients
                  .map(
                    (item) => InputChip(
                      label: Text(item),
                      onDeleted: _busy ? null : () => _removeIngredient(item),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    enabled: !_busy,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addIngredient(),
                    decoration: const InputDecoration(
                      labelText: 'Add an ingredient',
                      hintText: 'e.g. garlic',
                      prefixIcon: Icon(Icons.add),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _busy ? null : _addIngredient,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add ingredient',
                ),
              ],
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: const Text('Save captured dish'),
            ),
          ],
        ],
      ),
    );
  }
}
