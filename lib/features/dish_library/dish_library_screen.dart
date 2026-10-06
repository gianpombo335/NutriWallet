import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/allergy/dish_allergy_matcher.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/currency/app_currency.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';

class DishLibraryScreen extends ConsumerWidget {
  const DishLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider).value;
    final currency = ref.watch(currencyProvider);
    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return StreamBuilder(
      stream: ref.watch(dishRepositoryProvider).watchDishes(profile.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Could not load your dishes.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final dishes = snapshot.data ?? [];
        if (dishes.isEmpty) {
          return _EmptyDishState(onAdd: () => context.push('/dishes/new'));
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            4,
            AppSpacing.page,
            96,
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 230,
            mainAxisExtent: 170,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: dishes.length,
          itemBuilder: (context, index) {
            final dish = dishes[index];
            return _DishCard(
              dish: dish,
              profileId: profile.id,
              currency: currency,
              onTap: () => context.push('/dishes/${dish.id}'),
            );
          },
        );
      },
    );
  }
}

class _DishCard extends ConsumerWidget {
  const _DishCard({
    required this.dish,
    required this.profileId,
    required this.currency,
    required this.onTap,
  });

  final Dishe dish;
  final int profileId;
  final AppCurrency currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref
          .read(dishRepositoryProvider)
          .ingredientsForDishForProfile(profileId: profileId, dishId: dish.id),
      builder: (context, snapshot) {
        final ingredients = snapshot.data ?? const <Ingredient>[];
        final exclusions = ref
            .watch(profileDaoProvider)
            .allergensForProfile(profileId);
        return FutureBuilder(
          future: exclusions,
          builder: (context, allergySnapshot) {
            final matches = findDishAllergyMatches(
              dishName: dish.name,
              ingredients: ingredients.map((item) => item.name),
              exclusions: (allergySnapshot.data ?? const []).map(
                (tag) => tag.label,
              ),
            );
            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 58,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF1EC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: dish.photoPath == null
                                ? const Icon(Icons.restaurant_rounded, size: 32)
                                : Image.file(
                                    File(dish.photoPath!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const Icon(
                                      Icons.restaurant_rounded,
                                      size: 32,
                                    ),
                                  ),
                          ),
                          if (matches.isNotEmpty)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Tooltip(
                                message: 'Matches a saved allergy/exclusion',
                                child: Icon(
                                  Icons.warning_amber_rounded,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        dish.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${currency.formatCents(dish.priceCents)} per serving',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyDishState extends StatelessWidget {
  const _EmptyDishState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restaurant_menu_outlined, size: 64),
            const SizedBox(height: 16),
            Text(
              'Your library is ready for its first dish.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Add something you already cook. It will become the building block for your weekly plan.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add your first dish'),
            ),
          ],
        ),
      ),
    );
  }
}
