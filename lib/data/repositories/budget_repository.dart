import '../local/daos/budget_dao.dart';
import '../local/database.dart';
import 'meal_plan_repository.dart';
import '../remote/sync_service.dart';

class BudgetRepository {
  BudgetRepository(this._database) : _dao = BudgetDao(_database);

  final AppDatabase _database;
  final BudgetDao _dao;

  Stream<List<BudgetEntry>> watchEntries(
    int profileId, {
    DateTime? from,
    DateTime? until,
  }) => _dao.watchForProfile(profileId, from: from, until: until);

  Future<int> addEntry({
    required int profileId,
    required int amountCents,
    required String label,
    required DateTime occurredAt,
    int? generatedPlanId,
    int? mealSlotId,
  }) async {
    final id = await _dao.addEntry(
      profileId: profileId,
      amountCents: amountCents,
      label: label,
      occurredAt: occurredAt,
      generatedPlanId: generatedPlanId,
      mealSlotId: mealSlotId,
    );
    await SyncQueueRepository(_database).enqueue(
      entityTable: 'BudgetEntries',
      entityId: id,
      operation: 'insert',
      payload: {
        'profile_id': profileId,
        'amount_cents': amountCents,
        'label': label,
        'occurred_at': occurredAt.toUtc().toIso8601String(),
        'generated_plan_id': generatedPlanId,
        'meal_slot_id': mealSlotId,
      },
    );
    return id;
  }

  int actualTotal(Iterable<BudgetEntry> entries) =>
      entries.fold(0, (sum, entry) => sum + entry.amountCents);

  Future<void> deleteEntry(BudgetEntry entry) async {
    await _dao.deleteEntry(entry.id);
    if (entry.mealSlotId != null) {
      await MealPlanRepository(_database).updateMealSlot(
        profileId: entry.userProfileId,
        slotId: entry.mealSlotId!,
        mealStatus: 'planned',
        consumedAt: null,
      );
    }
    await SyncQueueRepository(_database).enqueue(
      entityTable: 'BudgetEntries',
      entityId: entry.id,
      operation: 'delete',
      payload: {
        'profile_id': entry.userProfileId,
        'meal_slot_id': entry.mealSlotId,
      },
    );
  }

  Future<void> clearMealSlotExpense(int mealSlotId) async {
    final existing = await _dao.findByMealSlotId(mealSlotId);
    if (existing != null) await _dao.deleteEntry(existing.id);
  }

  Future<void> updateEntry({
    required BudgetEntry entry,
    required int amountCents,
    required String label,
    required DateTime occurredAt,
    required int? generatedPlanId,
    int? mealSlotId,
  }) async {
    await _dao.updateEntry(
      entryId: entry.id,
      amountCents: amountCents,
      label: label,
      occurredAt: occurredAt,
      generatedPlanId: generatedPlanId,
      mealSlotId: mealSlotId,
    );
    await SyncQueueRepository(_database).enqueue(
      entityTable: 'BudgetEntries',
      entityId: entry.id,
      operation: 'update',
      payload: {
        'profile_id': entry.userProfileId,
        'amount_cents': amountCents,
        'label': label,
        'occurred_at': occurredAt.toUtc().toIso8601String(),
        'generated_plan_id': generatedPlanId,
        'meal_slot_id': mealSlotId,
      },
    );
  }

  Future<void> upsertMealSlotExpense({
    required int profileId,
    required int mealSlotId,
    required int amountCents,
    required String label,
    required DateTime occurredAt,
    required int generatedPlanId,
  }) async {
    final existing = await _dao.findByMealSlotId(mealSlotId);
    if (existing == null) {
      await addEntry(
        profileId: profileId,
        amountCents: amountCents,
        label: label,
        occurredAt: occurredAt,
        generatedPlanId: generatedPlanId,
        mealSlotId: mealSlotId,
      );
      return;
    }
    await updateEntry(
      entry: existing,
      amountCents: amountCents,
      label: label,
      occurredAt: occurredAt,
      generatedPlanId: generatedPlanId,
      mealSlotId: mealSlotId,
    );
  }
}
