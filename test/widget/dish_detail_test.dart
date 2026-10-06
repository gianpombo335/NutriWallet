import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';

import 'package:nutriwallet/core/providers.dart';
import 'package:nutriwallet/data/local/daos/dish_dao.dart';
import 'package:nutriwallet/data/local/daos/profile_dao.dart';
import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/repositories/dish_repository.dart';
import 'package:nutriwallet/features/dish_library/dish_detail_screen.dart';

void main() {
  testWidgets('dish detail renders a placeholder for empty ingredients', (
    tester,
  ) async {
    final database = AppDatabase();
    addTearDown(database.close);
    final profileId = await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'widget@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final dishId = await DishDao(database).insertDish(
      DishesCompanion.insert(
        userProfileId: profileId,
        name: 'Plain toast',
        priceCents: 100,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final profile = await ProfileDao(database).findById(profileId);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          dishRepositoryProvider.overrideWithValue(DishRepository(database)),
          profileDaoProvider.overrideWithValue(ProfileDao(database)),
          currentProfileProvider.overrideWith((ref) async => profile),
        ],
        child: const MaterialApp(home: DishDetailScreen(dishId: 1)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No ingredients added yet.'), findsOneWidget);
    expect(dishId, 1);
  });

  testWidgets('dish detail renders complete ingredient nutrition', (
    tester,
  ) async {
    final database = AppDatabase();
    addTearDown(database.close);
    final profileId = await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'nutrition@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final dishId = await DishDao(database).insertDish(
      DishesCompanion.insert(
        userProfileId: profileId,
        name: 'Protein bowl',
        priceCents: 500,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    await DishDao(database).insertIngredient(
      IngredientsCompanion.insert(
        dishId: dishId,
        name: 'Beans',
        calories: const Value(300),
        proteinG: const Value(20),
        carbsG: const Value(45),
        fatG: const Value(5),
      ),
    );
    final profile = await ProfileDao(database).findById(profileId);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          dishRepositoryProvider.overrideWithValue(DishRepository(database)),
          profileDaoProvider.overrideWithValue(ProfileDao(database)),
          currentProfileProvider.overrideWith((ref) async => profile),
        ],
        child: MaterialApp(home: DishDetailScreen(dishId: dishId)),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('300 kcal  •  20.0 g protein\n45.0 g carbs  •  5.0 g fat'),
      findsOneWidget,
    );
    expect(find.text('300 kcal'), findsWidgets);
    expect(find.text('20 g'), findsOneWidget);
    expect(find.text('45 g'), findsOneWidget);
    expect(find.text('5 g'), findsOneWidget);
  });

  testWidgets('dish detail warns about a matching saved exclusion', (
    tester,
  ) async {
    final database = AppDatabase();
    addTearDown(database.close);
    final profileId = await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'allergy@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    await ProfileDao(database).addAllergen(profileId, 'peanut');
    final dishId = await DishDao(database).insertDish(
      DishesCompanion.insert(
        userProfileId: profileId,
        name: 'Breakfast bowl',
        priceCents: 500,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    await DishDao(database).insertIngredient(
      IngredientsCompanion.insert(dishId: dishId, name: 'Peanut butter'),
    );
    final profile = await ProfileDao(database).findById(profileId);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          dishRepositoryProvider.overrideWithValue(DishRepository(database)),
          profileDaoProvider.overrideWithValue(ProfileDao(database)),
          currentProfileProvider.overrideWith((ref) async => profile),
        ],
        child: MaterialApp(home: DishDetailScreen(dishId: dishId)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Check this dish'), findsOneWidget);
    expect(find.textContaining('peanut'), findsOneWidget);
  });
}
