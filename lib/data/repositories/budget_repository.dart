import 'package:drift/drift.dart';

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
    _validateEntry(amountCents, label);
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
    if (existing == null) return;
    await _dao.deleteEntry(existing.id);
    await SyncQueueRepository(_database).enqueue(
      entityTable: 'BudgetEntries',
      entityId: existing.id,
      operation: 'delete',
      payload: {
        'profile_id': existing.userProfileId,
        'meal_slot_id': mealSlotId,
      },
    );
    final slot = await (_database.select(
      _database.mealSlots,
    )..where((row) => row.id.equals(mealSlotId))).getSingleOrNull();
    if (slot != null) {
      final plan = await (_database.select(
        _database.generatedPlans,
      )..where((row) => row.id.equals(slot.generatedPlanId))).getSingleOrNull();
      if (plan != null) {
        await MealPlanRepository(_database).updateMealSlot(
          profileId: plan.userProfileId,
          slotId: mealSlotId,
          mealStatus: 'planned',
          consumedAt: null,
        );
      }
    }
  }

  Future<void> updateEntry({
    required BudgetEntry entry,
    required int amountCents,
    required String label,
    required DateTime occurredAt,
    required int? generatedPlanId,
    int? mealSlotId,
  }) async {
    _validateEntry(amountCents, label);
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
    if (entry.mealSlotId != null && mealSlotId != null) {
      final slot = await (_database.select(
        _database.mealSlots,
      )..where((row) => row.id.equals(entry.mealSlotId!))).getSingleOrNull();
      if (slot != null && slot.mealStatus != 'skipped') {
        await MealPlanRepository(_database).updateMealSlot(
          profileId: entry.userProfileId,
          slotId: slot.id,
          mealStatus: slot.mealStatus == 'planned' ? 'eaten' : slot.mealStatus,
          consumedAt: slot.consumedAt ?? occurredAt,
          actualCostCents: amountCents,
          substituteName: slot.substituteName,
        );
      }
    } else if (entry.mealSlotId != null && mealSlotId == null) {
      final slot = await (_database.select(
        _database.mealSlots,
      )..where((row) => row.id.equals(entry.mealSlotId!))).getSingleOrNull();
      final plan = slot == null
          ? null
          : await (_database.select(_database.generatedPlans)
                  ..where((row) => row.id.equals(slot.generatedPlanId)))
                .getSingleOrNull();
      if (slot != null && plan != null) {
        await MealPlanRepository(_database).updateMealSlot(
          profileId: plan.userProfileId,
          slotId: slot.id,
          mealStatus: 'planned',
          consumedAt: null,
        );
      }
    }
  }

  void _validateEntry(int amountCents, String label) {
    if (amountCents < 0 || amountCents > 1000000000) {
      throw ArgumentError.value(amountCents, 'amountCents');
    }
    if (label.trim().length > 200) {
      throw ArgumentError.value(label, 'label');
    }
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

  Future<void> recordMealCheckIn({
    required int profileId,
    required int planId,
    required int slotId,
    required String mealStatus,
    required DateTime consumedAt,
    int? actualCostCents,
    String? substituteName,
    required String label,
  }) async {
    const validStatuses = {'eaten', 'substitute', 'skipped'};
    if (!validStatuses.contains(mealStatus)) {
      throw ArgumentError.value(mealStatus, 'mealStatus');
    }
    if (mealStatus == 'substitute' &&
        (actualCostCents == null ||
            actualCostCents < 0 ||
            substituteName?.trim().isEmpty != false)) {
      throw ArgumentError('Substitute meals require a name and actual cost.');
    }
    if (mealStatus == 'eaten' &&
        (actualCostCents == null || actualCostCents < 0)) {
      throw ArgumentError('Eaten meals require a non-negative actual cost.');
    }
    if (mealStatus == 'skipped' &&
        (actualCostCents != null || substituteName != null)) {
      throw ArgumentError('Skipped meals cannot have expense details.');
    }

    final slot =
        await (_database.select(_database.mealSlots)..where(
              (row) =>
                  row.id.equals(slotId) & row.generatedPlanId.equals(planId),
            ))
            .getSingleOrNull();
    final plan =
        await (_database.select(_database.generatedPlans)..where(
              (row) =>
                  row.id.equals(planId) & row.userProfileId.equals(profileId),
            ))
            .getSingleOrNull();
    if (slot == null || plan == null) return;

    await _database.transaction(() async {
      final changedAt = DateTime.now().toUtc();
      await (_database.update(
        _database.mealSlots,
      )..where((row) => row.id.equals(slotId))).write(
        MealSlotsCompanion(
          mealStatus: Value(mealStatus),
          actualCostCents: Value(actualCostCents),
          substituteName: Value(substituteName),
          consumedAt: Value(consumedAt.toUtc()),
        ),
      );
      final queue = SyncQueueRepository(_database);
      await queue.enqueue(
        entityTable: 'MealSlots',
        entityId: slot.id,
        operation: 'update',
        payload: {
          'profile_id': profileId,
          'generated_plan_id': slot.generatedPlanId,
          'dish_id': slot.dishId,
          'day_index': slot.dayIndex,
          'slot_index': slot.slotIndex,
          'planned_cost_cents': slot.plannedCostCents,
          'planned_calories': slot.plannedCalories,
          'planned_protein_g': slot.plannedProteinG,
          'planned_carbs_g': slot.plannedCarbsG,
          'planned_fat_g': slot.plannedFatG,
          'servings': slot.servings,
          'meal_status': mealStatus,
          'actual_cost_cents': actualCostCents,
          'substitute_name': substituteName,
          'consumed_at': consumedAt.toUtc().toIso8601String(),
        },
        dirtyAt: changedAt,
      );

      final existing = await _dao.findByMealSlotId(slotId);
      if (mealStatus == 'skipped') {
        if (existing != null) {
          await _dao.deleteEntry(existing.id);
          await queue.enqueue(
            entityTable: 'BudgetEntries',
            entityId: existing.id,
            operation: 'delete',
            payload: {'profile_id': profileId, 'meal_slot_id': slotId},
            dirtyAt: changedAt,
          );
        }
        return;
      }

      if (existing == null) {
        final entryId = await _dao.addEntry(
          profileId: profileId,
          amountCents: actualCostCents!,
          label: label,
          occurredAt: consumedAt,
          generatedPlanId: planId,
          mealSlotId: slotId,
        );
        await queue.enqueue(
          entityTable: 'BudgetEntries',
          entityId: entryId,
          operation: 'insert',
          payload: {
            'profile_id': profileId,
            'amount_cents': actualCostCents,
            'label': label,
            'occurred_at': consumedAt.toUtc().toIso8601String(),
            'generated_plan_id': planId,
            'meal_slot_id': slotId,
          },
          dirtyAt: changedAt,
        );
      } else {
        await _dao.updateEntry(
          entryId: existing.id,
          amountCents: actualCostCents!,
          label: label,
          occurredAt: consumedAt,
          generatedPlanId: planId,
          mealSlotId: slotId,
        );
        await queue.enqueue(
          entityTable: 'BudgetEntries',
          entityId: existing.id,
          operation: 'update',
          payload: {
            'profile_id': profileId,
            'amount_cents': actualCostCents,
            'label': label,
            'occurred_at': consumedAt.toUtc().toIso8601String(),
            'generated_plan_id': planId,
            'meal_slot_id': slotId,
          },
          dirtyAt: changedAt,
        );
      }
    });
  }
}
