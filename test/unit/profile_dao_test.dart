import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/data/local/daos/profile_dao.dart';
import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/remote/sync_service.dart';

void main() {
  test('profile setup payload accepts optional metrics', () async {
    final database = AppDatabase();
    addTearDown(database.close);
    final dao = ProfileDao(database);
    final id = await dao.save(
      UserProfilesCompanion.insert(
        email: 'setup@example.com',
        weeklyBudgetCents: const Value(7500),
        mealsPerDay: const Value(3),
        weightKg: const Value(null),
        heightCm: const Value(null),
        age: const Value(null),
        sex: const Value('male'),
        activityLevel: const Value('moderate'),
        goalPreset: const Value('balanced'),
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );

    final profile = await dao.findById(id);
    expect(profile?.weeklyBudgetCents, 7500);
    expect(profile?.weightKg, isNull);
    expect(profile?.goalPreset, 'balanced');
    expect(
      userProfileSyncPayload(profile!),
      containsPair('email', 'setup@example.com'),
    );
    expect(
      userProfileSyncPayload(profile),
      containsPair('weekly_budget_cents', 7500),
    );
  });

  test(
    'profile edits persist schedule, metrics, and nutrition choices',
    () async {
      final database = AppDatabase();
      addTearDown(database.close);
      final dao = ProfileDao(database);
      final id = await dao.save(
        UserProfilesCompanion.insert(
          email: 'edit@example.com',
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        ),
      );

      await dao.updateProfile(
        UserProfilesCompanion(
          id: Value(id),
          weeklyBudgetCents: const Value(12500),
          activeDays: const Value('1,3,5'),
          mealsPerDay: const Value(4),
          weightKg: const Value(72.5),
          heightCm: const Value(178),
          age: const Value(31),
          sex: const Value('female'),
          activityLevel: const Value('active'),
          goalPreset: const Value('high_protein'),
          updatedAt: Value(DateTime.utc(2026, 1, 2)),
        ),
      );

      final profile = await dao.findById(id);
      expect(profile?.weeklyBudgetCents, 12500);
      expect(profile?.activeDays, '1,3,5');
      expect(profile?.mealsPerDay, 4);
      expect(profile?.weightKg, 72.5);
      expect(profile?.goalPreset, 'high_protein');
    },
  );

  test('profile edits update only the selected profile', () async {
    final database = AppDatabase();
    addTearDown(database.close);
    final dao = ProfileDao(database);
    final first = await dao.save(
      UserProfilesCompanion.insert(
        email: 'first@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final second = await dao.save(
      UserProfilesCompanion.insert(
        email: 'second@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );

    await dao.updateProfile(
      UserProfilesCompanion(
        id: Value(first),
        weeklyBudgetCents: const Value(9000),
        updatedAt: Value(DateTime.utc(2026, 1, 2)),
      ),
    );

    expect((await dao.findById(first))?.weeklyBudgetCents, 9000);
    expect((await dao.findById(second))?.weeklyBudgetCents, 0);
  });
}
