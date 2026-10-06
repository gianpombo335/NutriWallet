import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/allergy/dish_allergy_matcher.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';

class DishDetailScreen extends ConsumerStatefulWidget {
  const DishDetailScreen({required this.dishId, super.key});

  final int dishId;

  @override
  ConsumerState<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends ConsumerState<DishDetailScreen> {
  late Future<_DishDetailData?> _data;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_DishDetailData?> _load() async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) return null;
    final repository = ref.read(dishRepositoryProvider);
    final dish = await repository.findByIdForProfile(
      profileId: profile.id,
      dishId: widget.dishId,
    );
    if (dish == null) return null;
    final ingredients = await repository.ingredientsForDishForProfile(
      profileId: profile.id,
      dishId: dish.id,
    );
    final exclusions = await ref
        .read(profileDaoProvider)
        .allergensForProfile(profile.id);
    return _DishDetailData(
      dish: dish,
      ingredients: ingredients,
      allergyMatches: findDishAllergyMatches(
        dishName: dish.name,
        ingredients: ingredients.map((item) => item.name),
        exclusions: exclusions.map((item) => item.label),
      ),
    );
  }

  void _reload() => setState(() => _data = _load());

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Dishe dish,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove dish?'),
        content: Text('Remove ${dish.name} from your dish library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref
        .read(dishRepositoryProvider)
        .deleteDish(profileId: dish.userProfileId, dishId: dish.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Could not load this dish.')),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final data = snapshot.data;
        final dish = data?.dish;
        final ingredients = data?.ingredients ?? const <Ingredient>[];
        if (dish == null) {
          return const Scaffold(body: Center(child: Text('Dish not found.')));
        }
        final currency = ref.watch(currencyProvider);
        final calories = ingredients.fold<double>(
          0,
          (sum, ingredient) => sum + ingredient.calories,
        );
        final proteinG = ingredients.fold<double>(
          0,
          (sum, ingredient) => sum + ingredient.proteinG,
        );
        final carbsG = ingredients.fold<double>(
          0,
          (sum, ingredient) => sum + ingredient.carbsG,
        );
        final fatG = ingredients.fold<double>(
          0,
          (sum, ingredient) => sum + ingredient.fatG,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(dish.name),
            actions: [
              IconButton(
                onPressed: () async {
                  final changed = await context.push<bool>(
                    '/dishes/${dish.id}/edit',
                  );
                  if (changed == true && mounted) _reload();
                },
                tooltip: 'Edit dish',
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => _confirmDelete(context, ref, dish),
                tooltip: 'Remove dish',
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.page),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${currency.formatCents(dish.priceCents)} per serving',
                      ),
                    ],
                  ),
                ),
              ),
              if (data!.allergyMatches.isNotEmpty) ...[
                const SizedBox(height: 12),
                _AllergyWarning(matches: data.allergyMatches),
              ],
              const SizedBox(height: AppSpacing.section),
              if (ingredients.isNotEmpty) ...[
                Text(
                  'Nutrition per serving',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _NutritionCard(
                  calories: calories,
                  proteinG: proteinG,
                  carbsG: carbsG,
                  fatG: fatG,
                ),
                const SizedBox(height: AppSpacing.section),
              ],
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (ingredients.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No ingredients added yet.'),
                  ),
                )
              else
                ...ingredients.map(
                  (ingredient) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.circle, size: 10),
                    title: Text(ingredient.name),
                    subtitle: Text(
                      '${ingredient.calories.toStringAsFixed(0)} kcal  •  '
                      '${ingredient.proteinG.toStringAsFixed(1)} g protein\n'
                      '${ingredient.carbsG.toStringAsFixed(1)} g carbs  •  '
                      '${ingredient.fatG.toStringAsFixed(1)} g fat',
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DishDetailData {
  const _DishDetailData({
    required this.dish,
    required this.ingredients,
    required this.allergyMatches,
  });

  final Dishe dish;
  final List<Ingredient> ingredients;
  final List<DishAllergyMatch> allergyMatches;
}

class _AllergyWarning extends StatelessWidget {
  const _AllergyWarning({required this.matches});

  final List<DishAllergyMatch> matches;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labels = matches.map((match) => match.exclusion).toSet().join(', ');
    final sources = matches.map((match) => match.source).toSet().join(', ');
    return Card(
      color: colorScheme.errorContainer,
      child: ListTile(
        leading: Icon(Icons.warning_amber_rounded, color: colorScheme.error),
        title: const Text('Check this dish'),
        subtitle: Text(
          'Matches your saved allergy/exclusion: $labels. Found in: $sources.',
        ),
      ),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            _NutritionValue(
              label: 'Calories',
              value: '${calories.round()} kcal',
            ),
            _NutritionValue(label: 'Protein', value: '${proteinG.round()} g'),
            _NutritionValue(label: 'Carbs', value: '${carbsG.round()} g'),
            _NutritionValue(label: 'Fat', value: '${fatG.round()} g'),
          ],
        ),
      ),
    );
  }
}

class _NutritionValue extends StatelessWidget {
  const _NutritionValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
