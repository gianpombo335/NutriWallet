import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/data/local/daos/dish_dao.dart';
import 'package:nutriwallet/data/local/daos/profile_dao.dart';
import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/repositories/dish_repository.dart';

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase());
  tearDown(() => database.close());

  test('FR-05 inserts a dish and resolves its ingredients', () async {
    final profiles = ProfileDao(database);
    final profileId = await profiles.save(
      UserProfilesCompanion.insert(
        email: 'person@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final repository = DishRepository(database);

    final dish = await repository.createDish(
      profileId: profileId,
      name: 'Chickpea bowl',
      priceCents: 650,
      ingredients: const [
        IngredientDraft(
          name: 'chickpeas',
          calories: 220,
          proteinG: 12,
          carbsG: 35,
          fatG: 4,
        ),
      ],
    );

    final ingredients = await repository.ingredientsForDish(dish.id);
    expect(dish.name, 'Chickpea bowl');
    expect(ingredients, hasLength(1));
    expect(ingredients.single.name, 'chickpeas');
    final queue = await database.select(database.syncQueue).get();
    expect(queue.map((item) => item.entityTable), ['Dishes', 'Ingredients']);
    final ingredientPayload =
        jsonDecode(queue[1].payloadJson) as Map<String, dynamic>;
    expect(ingredientPayload['dish_id'], dish.id);
  });

  test('an empty ingredient list remains a valid dish relation', () async {
    final profiles = ProfileDao(database);
    final profileId = await profiles.save(
      UserProfilesCompanion.insert(
        email: 'empty@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final repository = DishRepository(database);

    final dish = await repository.createDish(
      profileId: profileId,
      name: 'Tea',
      priceCents: 100,
      ingredients: const [],
    );

    expect(await repository.ingredientsForDish(dish.id), isEmpty);
  });

  test('price range query returns only active dishes in range', () async {
    final profiles = ProfileDao(database);
    final profileId = await profiles.save(
      UserProfilesCompanion.insert(
        email: 'range@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final repository = DishRepository(database);
    await repository.createDish(
      profileId: profileId,
      name: 'Cheap',
      priceCents: 200,
      ingredients: const [],
    );
    await repository.createDish(
      profileId: profileId,
      name: 'Expensive',
      priceCents: 1200,
      ingredients: const [],
    );

    final rows = await repository.watchDishes(profileId).first;
    expect(rows, hasLength(2));
    final result = await DishDao(database)
        .findByPriceRange(profileId, 100, 500);
    expect(result.map((dish) => dish.name), contains('Cheap'));
    expect(result.map((dish) => dish.name), isNot(contains('Expensive')));
  });

  test('deleting a dish hides it and queues the delete operation', () async {
    final profiles = ProfileDao(database);
    final profileId = await profiles.save(
      UserProfilesCompanion.insert(
        email: 'delete@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final repository = DishRepository(database);
    final dish = await repository.createDish(
      profileId: profileId,
      name: 'Remove me',
      priceCents: 300,
      ingredients: const [],
    );

    await repository.deleteDish(profileId: profileId, dishId: dish.id);

    expect(await repository.watchDishes(profileId).first, isEmpty);
    final queue = await database.select(database.syncQueue).get();
    expect(queue.last.operation, 'delete');
    expect(queue.last.entityId, dish.id);
  });
}
