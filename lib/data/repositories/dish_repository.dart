import 'package:drift/drift.dart';

import '../local/daos/dish_dao.dart';
import '../local/database.dart';
import '../remote/sync_service.dart';
import '../../features/meal_planner/domain/planner_models.dart';

class IngredientDraft {
  const IngredientDraft({
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.existingId,
  });

  final int? existingId;
  final String name;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
}

class DishRepository {
  DishRepository(this._database) : _dao = DishDao(_database);

  final AppDatabase _database;
  final DishDao _dao;

  Stream<List<Dishe>> watchDishes(int profileId) =>
      _dao.watchForProfile(profileId);

  Future<List<Ingredient>> ingredientsForDish(int dishId) =>
      _dao.ingredientsForDish(dishId);

  Future<List<PlannerDish>> plannerDishes(int profileId) async {
    final savedDishes =
        await (_database.select(_database.dishes)..where(
              (dish) =>
                  dish.userProfileId.equals(profileId) &
                  dish.isDeleted.equals(false),
            ))
            .get();
    final result = <PlannerDish>[];
    for (final dish in savedDishes) {
      final ingredients = await _dao.ingredientsForDish(dish.id);
      result.add(
        PlannerDish(
          id: dish.id,
          name: dish.name,
          price: dish.priceCents / 100,
          calories: ingredients.fold(0, (sum, item) => sum + item.calories),
          proteinG: ingredients.fold(0, (sum, item) => sum + item.proteinG),
          carbsG: ingredients.fold(0, (sum, item) => sum + item.carbsG),
          fatG: ingredients.fold(0, (sum, item) => sum + item.fatG),
          ingredients: ingredients.map((item) => item.name).toList(),
        ),
      );
    }
    return result;
  }

  Future<Dishe> createDish({
    required int profileId,
    required String name,
    required int priceCents,
    required List<IngredientDraft> ingredients,
    String? cuisineTag,
    String source = 'manual',
    String? photoPath,
  }) async {
    _validateDish(name: name, priceCents: priceCents, ingredients: ingredients);
    final normalizedName = name.trim();
    return _database.transaction(() async {
      final now = DateTime.now().toUtc();
      final dishId = await _dao.insertDish(
        DishesCompanion.insert(
          userProfileId: profileId,
          name: normalizedName,
          priceCents: priceCents,
          source: Value(source),
          photoPath: Value(photoPath),
          cuisineTag: Value(
            cuisineTag?.trim().isEmpty == true ? null : cuisineTag?.trim(),
          ),
          createdAt: now,
          updatedAt: now,
        ),
      );
      final queue = SyncQueueRepository(_database);
      await queue.enqueue(
        entityTable: 'Dishes',
        entityId: dishId,
        operation: 'insert',
        payload: {
          'profile_id': profileId,
          'name': normalizedName,
          'price_cents': priceCents,
          'source': source,
          'cuisine_tag': cuisineTag?.trim().isEmpty == true
              ? null
              : cuisineTag?.trim(),
          'photo_path': photoPath,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        },
      );
      for (final ingredient in ingredients) {
        final ingredientId = await _dao.insertIngredient(
          IngredientsCompanion.insert(
            dishId: dishId,
            name: ingredient.name.trim(),
            calories: Value(ingredient.calories),
            proteinG: Value(ingredient.proteinG),
            carbsG: Value(ingredient.carbsG),
            fatG: Value(ingredient.fatG),
          ),
        );
        await queue.enqueue(
          entityTable: 'Ingredients',
          entityId: ingredientId,
          operation: 'insert',
          payload: {
            'dish_id': dishId,
            'name': ingredient.name.trim(),
            'quantity': 1,
            'unit': 'serving',
            'calories': ingredient.calories,
            'protein_g': ingredient.proteinG,
            'carbs_g': ingredient.carbsG,
            'fat_g': ingredient.fatG,
            'is_cached_from_api': false,
          },
        );
      }
      return (await _dao.findById(dishId))!;
    });
  }

  Future<Dishe?> findByIdForProfile({
    required int profileId,
    required int dishId,
  }) => _dao.findByIdForProfile(profileId, dishId);

  Future<List<Ingredient>> ingredientsForDishForProfile({
    required int profileId,
    required int dishId,
  }) async {
    final dish = await _dao.findByIdForProfile(profileId, dishId);
    if (dish == null) return const [];
    return _dao.ingredientsForDish(dishId);
  }

  Future<Dishe> updateDish({
    required int profileId,
    required int dishId,
    required String name,
    required int priceCents,
    required List<IngredientDraft> ingredients,
    String? cuisineTag,
  }) async {
    _validateDish(name: name, priceCents: priceCents, ingredients: ingredients);
    final normalizedName = name.trim();
    return _database.transaction(() async {
      final existing = await _dao.findByIdForProfile(profileId, dishId);
      if (existing == null || existing.isDeleted) {
        throw StateError('Dish not found.');
      }
      final oldIngredients = await _dao.ingredientsForDish(dishId);
      final retainedIds = <int>{};
      for (final ingredient in ingredients) {
        final existingId = ingredient.existingId;
        if (existingId == null) continue;
        final old = oldIngredients.where((item) => item.id == existingId);
        if (old.isEmpty) {
          throw ArgumentError.value(existingId, 'existingId');
        }
        retainedIds.add(existingId);
      }

      final now = DateTime.now().toUtc();
      await _dao.updateDish(
        dishId,
        DishesCompanion(
          name: Value(normalizedName),
          priceCents: Value(priceCents),
          cuisineTag: Value(
            cuisineTag?.trim().isEmpty == true ? null : cuisineTag?.trim(),
          ),
          updatedAt: Value(now),
        ),
      );

      final queue = SyncQueueRepository(_database);
      await queue.enqueue(
        entityTable: 'Dishes',
        entityId: dishId,
        operation: 'update',
        payload: {
          'profile_id': profileId,
          'name': normalizedName,
          'price_cents': priceCents,
          'source': existing.source,
          'cuisine_tag': cuisineTag?.trim().isEmpty == true
              ? null
              : cuisineTag?.trim(),
          'photo_path': existing.photoPath,
          'created_at': existing.createdAt.toUtc().toIso8601String(),
          'updated_at': now.toIso8601String(),
          'is_deleted': false,
        },
        dirtyAt: now,
      );

      for (final old in oldIngredients) {
        if (retainedIds.contains(old.id)) continue;
        await _dao.deleteIngredient(old.id);
        await queue.enqueue(
          entityTable: 'Ingredients',
          entityId: old.id,
          operation: 'delete',
          payload: {'profile_id': profileId, 'dish_id': dishId},
          dirtyAt: now,
        );
      }

      for (final ingredient in ingredients) {
        final normalizedIngredient = ingredient.name.trim();
        final values = IngredientsCompanion(
          name: Value(normalizedIngredient),
          quantity: const Value(1),
          unit: const Value('serving'),
          calories: Value(ingredient.calories),
          proteinG: Value(ingredient.proteinG),
          carbsG: Value(ingredient.carbsG),
          fatG: Value(ingredient.fatG),
          isCachedFromApi: const Value(false),
        );
        final existingId = ingredient.existingId;
        final ingredientId =
            existingId ??
            await _dao.insertIngredient(
              IngredientsCompanion.insert(
                dishId: dishId,
                name: normalizedIngredient,
                quantity: const Value(1),
                unit: const Value('serving'),
                calories: Value(ingredient.calories),
                proteinG: Value(ingredient.proteinG),
                carbsG: Value(ingredient.carbsG),
                fatG: Value(ingredient.fatG),
              ),
            );
        if (existingId != null) {
          await _dao.updateIngredient(existingId, values);
        }
        await queue.enqueue(
          entityTable: 'Ingredients',
          entityId: ingredientId,
          operation: existingId == null ? 'insert' : 'update',
          payload: {
            'profile_id': profileId,
            'dish_id': dishId,
            'name': normalizedIngredient,
            'quantity': 1,
            'unit': 'serving',
            'calories': ingredient.calories,
            'protein_g': ingredient.proteinG,
            'carbs_g': ingredient.carbsG,
            'fat_g': ingredient.fatG,
            'is_cached_from_api': false,
          },
          dirtyAt: now,
        );
      }
      return (await _dao.findById(dishId))!;
    });
  }

  Future<void> deleteDish({required int profileId, required int dishId}) async {
    final dish = await _dao.findById(dishId);
    if (dish == null || dish.userProfileId != profileId) return;
    await _dao.softDelete(dishId);
    await SyncQueueRepository(_database).enqueue(
      entityTable: 'Dishes',
      entityId: dishId,
      operation: 'delete',
      payload: {'profile_id': profileId},
    );
  }

  void _validateDish({
    required String name,
    required int priceCents,
    required List<IngredientDraft> ingredients,
  }) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty || normalizedName.length > 200) {
      throw ArgumentError.value(name, 'name');
    }
    if (priceCents < 0 || priceCents > 100000000) {
      throw ArgumentError.value(priceCents, 'priceCents');
    }
    final seenIngredients = <String>{};
    for (final ingredient in ingredients) {
      final normalizedIngredient = ingredient.name.trim().toLowerCase();
      if (normalizedIngredient.isEmpty ||
          normalizedIngredient.length > 200 ||
          !seenIngredients.add(normalizedIngredient) ||
          !ingredient.calories.isFinite ||
          !ingredient.proteinG.isFinite ||
          !ingredient.carbsG.isFinite ||
          !ingredient.fatG.isFinite ||
          ingredient.calories < 0 ||
          ingredient.proteinG < 0 ||
          ingredient.carbsG < 0 ||
          ingredient.fatG < 0) {
        throw ArgumentError.value(ingredient, 'ingredients');
      }
    }
  }
}
