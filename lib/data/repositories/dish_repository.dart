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
  });

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
    return _database.transaction(() async {
      final now = DateTime.now().toUtc();
      final dishId = await _dao.insertDish(
        DishesCompanion.insert(
          userProfileId: profileId,
          name: name.trim(),
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
          'name': name.trim(),
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
}
