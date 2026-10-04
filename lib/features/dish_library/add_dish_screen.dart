import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/providers.dart';
import '../../data/repositories/dish_repository.dart';
import '../../data/remote/nutrition_lookup_service.dart';

class AddDishScreen extends ConsumerStatefulWidget {
  const AddDishScreen({super.key});

  @override
  ConsumerState<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends ConsumerState<AddDishScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _ingredientsController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _cuisineController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final profile = ref.read(currentProfileProvider).value;
    if (name.isEmpty || price == null || price < 0 || profile == null) {
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
      for (final ingredientName in ingredientNames) {
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
      await ref
          .read(dishRepositoryProvider)
          .createDish(
            profileId: profile.id,
            name: name,
            priceCents: (price * 100).round(),
            cuisineTag: _cuisineController.text,
            ingredients: enrichedIngredients,
          );
      if (!mounted) return;
      if (lookupFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dish saved. Some nutrition data is pending.'),
          ),
        );
      }
      context.pop();
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
      appBar: AppBar(title: const Text('Add dish')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          Text(
            'Keep it simple',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'You can add nutrition details later. A name and price are enough to start planning.',
          ),
          const SizedBox(height: 24),
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
            onPressed: _saving ? null : _save,
            child: _saving
                ? const CircularProgressIndicator()
                : const Text('Save dish'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push('/dishes/capture'),
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('Recognize from a photo'),
          ),
        ],
      ),
    );
  }
}
