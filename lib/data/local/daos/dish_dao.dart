import 'package:drift/drift.dart';

import '../database.dart';

part 'dish_dao.g.dart';

@DriftAccessor(tables: [Dishes, Ingredients])
class DishDao extends DatabaseAccessor<AppDatabase> with _$DishDaoMixin {
  DishDao(super.db);

  Stream<List<Dishe>> watchForProfile(int profileId) {
    return (select(dishes)
          ..where(
            (dish) =>
                dish.userProfileId.equals(profileId) &
                dish.isDeleted.equals(false),
          )
          ..orderBy([
            (dish) => OrderingTerm(
              expression: dish.updatedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  Future<Dishe?> findById(int id) =>
      (select(dishes)..where((dish) => dish.id.equals(id))).getSingleOrNull();

  Future<Dishe?> findByIdForProfile(int profileId, int dishId) =>
      (select(dishes)..where(
            (dish) =>
                dish.id.equals(dishId) & dish.userProfileId.equals(profileId),
          ))
          .getSingleOrNull();

  Future<List<Dishe>> findByPriceRange(
    int profileId,
    int minimumCents,
    int maximumCents,
  ) {
    return (select(dishes)..where(
          (dish) =>
              dish.userProfileId.equals(profileId) &
              dish.priceCents.isBetweenValues(minimumCents, maximumCents) &
              dish.isDeleted.equals(false),
        ))
        .get();
  }

  Future<List<Dishe>> findByNutrientRange(
    int profileId,
    double minimumProtein,
    double maximumCalories,
  ) async {
    final rows = await select(dishes)
        .join([innerJoin(ingredients, ingredients.dishId.equalsExp(dishes.id))])
        .get();
    final grouped = <int, List<Ingredient>>{};
    for (final row in rows) {
      grouped
          .putIfAbsent(row.readTable(dishes).id, () => [])
          .add(row.readTable(ingredients));
    }
    return grouped.entries
        .where((entry) {
          final protein = entry.value.fold<double>(
            0,
            (sum, item) => sum + item.proteinG,
          );
          final calories = entry.value.fold<double>(
            0,
            (sum, item) => sum + item.calories,
          );
          return entry.value.isNotEmpty &&
              protein >= minimumProtein &&
              calories <= maximumCalories;
        })
        .map(
          (entry) => rows
              .firstWhere((row) => row.readTable(dishes).id == entry.key)
              .readTable(dishes),
        )
        .where((dish) => dish.userProfileId == profileId && !dish.isDeleted)
        .toList();
  }

  Future<List<Ingredient>> ingredientsForDish(int dishId) => (select(
    ingredients,
  )..where((ingredient) => ingredient.dishId.equals(dishId))).get();

  Future<int> insertDish(DishesCompanion dish) => into(dishes).insert(dish);

  Future<int> insertIngredient(IngredientsCompanion ingredient) =>
      into(ingredients).insert(ingredient);

  Future<int> updateDish(int dishId, DishesCompanion dish) =>
      (update(dishes)..where((row) => row.id.equals(dishId))).write(dish);

  Future<int> updateIngredient(
    int ingredientId,
    IngredientsCompanion ingredient,
  ) => (update(
    ingredients,
  )..where((row) => row.id.equals(ingredientId))).write(ingredient);

  Future<int> deleteIngredient(int ingredientId) =>
      (delete(ingredients)..where((row) => row.id.equals(ingredientId))).go();

  Future<void> softDelete(int dishId) =>
      (update(dishes)..where((dish) => dish.id.equals(dishId))).write(
        DishesCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
}
