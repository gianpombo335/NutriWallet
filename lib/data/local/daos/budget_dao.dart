import 'package:drift/drift.dart';

import '../database.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [BudgetEntries])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  Stream<List<BudgetEntry>> watchForProfile(
    int profileId, {
    DateTime? from,
    DateTime? until,
  }) {
    final query = select(budgetEntries)
      ..where((row) {
        var predicate = row.userProfileId.equals(profileId);
        if (from != null) {
          predicate = predicate & row.occurredAt.isBiggerOrEqualValue(from);
        }
        if (until != null) {
          predicate = predicate & row.occurredAt.isSmallerThanValue(until);
        }
        return predicate;
      })
      ..orderBy([(row) => OrderingTerm.desc(row.occurredAt)]);
    return query.watch();
  }

  Future<int> addEntry({
    required int profileId,
    required int amountCents,
    required String label,
    required DateTime occurredAt,
    int? generatedPlanId,
    int? mealSlotId,
  }) {
    return into(budgetEntries).insert(
      BudgetEntriesCompanion.insert(
        userProfileId: profileId,
        generatedPlanId: Value(generatedPlanId),
        mealSlotId: Value(mealSlotId),
        amountCents: amountCents,
        label: label.trim().isEmpty ? 'Grocery trip' : label.trim(),
        occurredAt: occurredAt,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<void> deleteEntry(int entryId) =>
      (delete(budgetEntries)..where((row) => row.id.equals(entryId))).go();

  Future<void> updateEntry({
    required int entryId,
    required int amountCents,
    required String label,
    required DateTime occurredAt,
    required int? generatedPlanId,
    required int? mealSlotId,
  }) {
    return (update(
      budgetEntries,
    )..where((row) => row.id.equals(entryId))).write(
      BudgetEntriesCompanion(
        amountCents: Value(amountCents),
        label: Value(label.trim().isEmpty ? 'Grocery trip' : label.trim()),
        occurredAt: Value(occurredAt),
        generatedPlanId: Value(generatedPlanId),
        mealSlotId: Value(mealSlotId),
      ),
    );
  }

  Future<BudgetEntry?> findByMealSlotId(int mealSlotId) => (select(
    budgetEntries,
  )..where((row) => row.mealSlotId.equals(mealSlotId))).getSingleOrNull();
}
