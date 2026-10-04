import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/core/providers.dart';
import 'package:nutriwallet/data/local/daos/dish_dao.dart';
import 'package:nutriwallet/data/local/daos/profile_dao.dart';
import 'package:nutriwallet/data/local/database.dart';
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

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dishDaoProvider.overrideWithValue(DishDao(database))],
        child: const MaterialApp(home: DishDetailScreen(dishId: 1)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No ingredients added yet.'), findsOneWidget);
    expect(dishId, 1);
  });
}
