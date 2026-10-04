import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/repositories/budget_repository.dart';
import 'package:nutriwallet/data/local/daos/profile_dao.dart';

void main() {
  test('actual spend is persisted and queued for sync', () async {
    final database = AppDatabase();
    addTearDown(database.close);
    final profileId = await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'budget@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final repository = BudgetRepository(database);

    await repository.addEntry(
      profileId: profileId,
      amountCents: 1250,
      label: 'Market',
      occurredAt: DateTime.utc(2026, 1, 5),
    );

    final entries = await repository.watchEntries(profileId).first;
    expect(repository.actualTotal(entries), 1250);
    expect(await (database.select(database.syncQueue)).get(), hasLength(1));
  });

  test('budget stream can restrict entries to the current week', () async {
    final database = AppDatabase();
    addTearDown(database.close);
    final profileId = await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'weekly-budget@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final repository = BudgetRepository(database);

    await repository.addEntry(
      profileId: profileId,
      amountCents: 500,
      label: 'Previous week',
      occurredAt: DateTime.utc(2025, 12, 31),
    );
    await repository.addEntry(
      profileId: profileId,
      amountCents: 1250,
      label: 'Current week',
      occurredAt: DateTime.utc(2026, 1, 5),
    );

    final entries = await repository
        .watchEntries(
          profileId,
          from: DateTime.utc(2026, 1, 5),
          until: DateTime.utc(2026, 1, 12),
        )
        .first;
    expect(entries, hasLength(1));
    expect(entries.single.label, 'Current week');
  });

  test('expense updates persist and enqueue an update', () async {
    final database = AppDatabase();
    addTearDown(database.close);
    final profileId = await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'edit-budget@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final repository = BudgetRepository(database);
    await repository.addEntry(
      profileId: profileId,
      amountCents: 500,
      label: 'Market',
      occurredAt: DateTime.utc(2026, 1, 5),
    );
    final entry = await repository
        .watchEntries(profileId)
        .first
        .then((entries) => entries.single);

    await repository.updateEntry(
      entry: entry,
      amountCents: 850,
      label: 'Weekly groceries',
      occurredAt: DateTime.utc(2026, 1, 6),
      generatedPlanId: null,
    );

    final updated = await repository.watchEntries(profileId).first;
    expect(updated.single.amountCents, 850);
    expect(updated.single.label, 'Weekly groceries');
    expect(
      (await (database.select(
        database.syncQueue,
      )).get()).map((item) => item.operation),
      contains('update'),
    );
  });
}
