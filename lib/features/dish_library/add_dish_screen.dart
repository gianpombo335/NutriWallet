import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';
import '../../data/repositories/dish_repository.dart';
import '../../data/remote/nutrition_lookup_service.dart';

class AddDishScreen extends ConsumerStatefulWidget {
  const AddDishScreen({this.dishId, super.key});

  final int? dishId;

  @override
  ConsumerState<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends ConsumerState<AddDishScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _ingredientsController = TextEditingController();
  bool _saving = false;
  bool _loadingExisting = false;
  bool _loadFailed = false;
  List<Ingredient> _initialIngredients = const [];

  bool get _isEditing => widget.dishId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) Future<void>.microtask(_loadExistingDish);
  }

  Future<void> _loadExistingDish() async {
    setState(() => _loadingExisting = true);
    try {
      final profile = await ref.read(currentProfileProvider.future);
      if (profile == null) throw StateError('Profile not found.');
      final repository = ref.read(dishRepositoryProvider);
      final dish = await repository.findByIdForProfile(
        profileId: profile.id,
        dishId: widget.dishId!,
      );
      if (dish == null) throw StateError('Dish not found.');
      final ingredients = await repository.ingredientsForDishForProfile(
        profileId: profile.id,
        dishId: dish.id,
      );
      if (!mounted) return;
      _initialIngredients = ingredients;
      _nameController.text = dish.name;
      _priceController.text = (dish.priceCents / 100).toStringAsFixed(2);
      _cuisineController.text = dish.cuisineTag ?? '';
      _ingredientsController.text = ingredients
          .map((item) => item.name)
          .join(', ');
    } catch (_) {
      if (mounted) setState(() => _loadFailed = true);
    } finally {
      if (mounted) setState(() => _loadingExisting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _cuisineController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_loadingExisting || _loadFailed) return;
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final profile = ref.read(currentProfileProvider).value;
    if (name.isEmpty ||
        price == null ||
        !price.isFinite ||
        price < 0 ||
        price > 1000000 ||
        profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a dish name and a valid price.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final ingredientNames = _ingredientsController.text
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
      final nutrition = ref.read(nutritionLookupServiceProvider);
      final enrichedIngredients = <IngredientDraft>[];
      var lookupFailed = false;
      final normalizedInitial = {
        for (final ingredient in _initialIngredients)
          ingredient.name.trim().toLowerCase(): ingredient,
      };
      final seenNames = <String>{};
      for (final rawIngredientName in ingredientNames) {
        final ingredientName = rawIngredientName.trim();
        final normalizedIngredientName = ingredientName.toLowerCase();
        if (!seenNames.add(normalizedIngredientName)) continue;
        final unchanged = normalizedInitial[normalizedIngredientName];
        if (unchanged != null) {
          enrichedIngredients.add(
            IngredientDraft(
              existingId: unchanged.id,
              name: ingredientName,
              calories: unchanged.calories,
              proteinG: unchanged.proteinG,
              carbsG: unchanged.carbsG,
              fatG: unchanged.fatG,
            ),
          );
          continue;
        }
        NutritionProfile? nutritionProfile;
        try {
          nutritionProfile = await nutrition.lookup(ingredientName);
        } catch (_) {
          lookupFailed = true;
        }
        enrichedIngredients.add(
          IngredientDraft(
            name: ingredientName,
            calories: nutritionProfile?.calories ?? 0,
            proteinG: nutritionProfile?.proteinG ?? 0,
            carbsG: nutritionProfile?.carbsG ?? 0,
            fatG: nutritionProfile?.fatG ?? 0,
          ),
        );
      }
      final repository = ref.read(dishRepositoryProvider);
      if (_isEditing) {
        await repository.updateDish(
          profileId: profile.id,
          dishId: widget.dishId!,
          name: name,
          priceCents: (price * 100).round(),
          cuisineTag: _cuisineController.text,
          ingredients: enrichedIngredients,
        );
      } else {
        await repository.createDish(
          profileId: profile.id,
          name: name,
          priceCents: (price * 100).round(),
          cuisineTag: _cuisineController.text,
          ingredients: enrichedIngredients,
        );
      }
      if (!mounted) return;
      if (lookupFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dish saved. Some nutrition data is pending.'),
          ),
        );
      }
      context.pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save this dish. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit dish' : 'Add dish')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          Text(
            _isEditing ? 'Keep your dish up to date' : 'Keep it simple',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _isEditing
                ? 'Update the name, price, or ingredients. Existing nutrition data is kept when ingredients stay the same.'
                : 'You can add nutrition details later. A name and price are enough to start planning.',
          ),
          const SizedBox(height: 24),
          if (_loadingExisting)
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: LinearProgressIndicator(),
            ),
          if (_loadFailed)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'This dish could not be loaded. Go back and try again.',
                ),
              ),
            ),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Dish name *',
              prefixIcon: Icon(Icons.restaurant_menu),
            ),
          ),
          const SizedBox(height: AppSpacing.item),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price per serving *',
              prefixText: '${ref.watch(currencyProvider).symbol} ',
            ),
          ),
          const SizedBox(height: AppSpacing.item),
          TextField(
            controller: _cuisineController,
            decoration: const InputDecoration(
              labelText: 'Cuisine (optional)',
              prefixIcon: Icon(Icons.public),
            ),
          ),
          const SizedBox(height: AppSpacing.item),
          TextField(
            controller: _ingredientsController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Ingredients (optional)',
              hintText: 'rice, beans, tomato',
              prefixIcon: Icon(Icons.list_alt_outlined),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _saving || _loadingExisting || _loadFailed
                ? null
                : _save,
            child: _saving
                ? const CircularProgressIndicator()
                : Text(_isEditing ? 'Update dish' : 'Save dish'),
          ),
          if (!_isEditing) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.push('/dishes/capture'),
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Recognize from a photo'),
            ),
          ],
        ],
      ),
    );
  }
}
