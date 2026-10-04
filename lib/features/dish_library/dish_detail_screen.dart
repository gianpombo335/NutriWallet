import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';

class DishDetailScreen extends ConsumerWidget {
  const DishDetailScreen({required this.dishId, super.key});

  final int dishId;

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
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future.wait<Object?>([
        ref.watch(dishDaoProvider).findById(dishId),
        ref.watch(dishDaoProvider).ingredientsForDish(dishId),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final dish = snapshot.data![0] as Dishe?;
        final ingredients = snapshot.data![1] as List<Ingredient>;
        if (dish == null) {
          return const Scaffold(body: Center(child: Text('Dish not found.')));
        }
        final currency = ref.watch(currencyProvider);
        return Scaffold(
          appBar: AppBar(
            title: Text(dish.name),
            actions: [
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
              const SizedBox(height: AppSpacing.section),
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
                      '${ingredient.calories.toStringAsFixed(0)} kcal',
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
