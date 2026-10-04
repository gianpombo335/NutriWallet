import 'package:drift/drift.dart';

import '../../features/meal_planner/domain/planner_models.dart';
import '../local/daos/dish_dao.dart';
import '../local/database.dart';
import '../remote/sync_service.dart';

class MealPlanRepository {
  MealPlanRepository(this._database);

  final AppDatabase _database;

  Future<GeneratedPlan> savePlan({
    required int profileId,
    required DateTime weekStartDate,
    required GeneratedMealPlan plan,
    String planningFocus = 'balanced',
    String currencyCode = 'USD',
  }) async {
    return _database.transaction(() async {
      final now = DateTime.now().toUtc();
      final previous =
          await (_database.select(_database.generatedPlans)
                ..where((row) => row.userProfileId.equals(profileId))
                ..orderBy([(row) => OrderingTerm.desc(row.version)])
                ..limit(1))
              .getSingleOrNull();
      final version = (previous?.version ?? 0) + 1;
      await (_database.update(_database.generatedPlans)
            ..where((row) => row.userProfileId.equals(profileId)))
          .write(const GeneratedPlansCompanion(isActive: Value(false)));
      final queue = SyncQueueRepository(_database);
      if (previous != null && previous.isActive) {
        await queue.enqueue(
          entityTable: 'GeneratedPlans',
          entityId: previous.id,
          operation: 'update',
          payload: _planPayload(previous, isActive: false),
          dirtyAt: now,
        );
      }
      final planId = await _database
          .into(_database.generatedPlans)
          .insert(
            GeneratedPlansCompanion.insert(
              userProfileId: profileId,
              weekStartDate: weekStartDate,
              generatedAt: now,
              totalProjectedCostCents: plan.totalCostCents,
              isOverBudget: Value(plan.isOverBudget),
              version: version,
              isActive: const Value(true),
              planningFocus: Value(planningFocus),
              currencyCode: Value(currencyCode),
            ),
          );
      await queue.enqueue(
        entityTable: 'GeneratedPlans',
        entityId: planId,
        operation: 'insert',
        payload: {
          'profile_id': profileId,
          'week_start_date': weekStartDate.toUtc().toIso8601String(),
          'generated_at': now.toIso8601String(),
          'total_projected_cost_cents': plan.totalCostCents,
          'is_over_budget': plan.isOverBudget,
          'version': version,
          'is_active': true,
          'planning_focus': planningFocus,
          'currency_code': currencyCode,
        },
        dirtyAt: now,
      );
      for (final assignment in plan.assignments) {
        final slotId = await _database
            .into(_database.mealSlots)
            .insert(
              MealSlotsCompanion.insert(
                generatedPlanId: planId,
                dayIndex: assignment.dayIndex,
                slotIndex: assignment.slotIndex,
                dishId: assignment.dish.id,
                plannedCostCents: assignment.dish.roundedPriceCents,
                plannedCalories: Value(assignment.dish.calories),
              ),
            );
        await queue.enqueue(
          entityTable: 'MealSlots',
          entityId: slotId,
          operation: 'insert',
          payload: {
            'profile_id': profileId,
            'generated_plan_id': planId,
            'dish_id': assignment.dish.id,
            'day_index': assignment.dayIndex,
            'slot_index': assignment.slotIndex,
            'planned_cost_cents': assignment.dish.roundedPriceCents,
            'planned_calories': assignment.dish.calories,
            'meal_status': 'planned',
          },
          dirtyAt: now,
        );
      }
      return (_database.select(
        _database.generatedPlans,
      )..where((row) => row.id.equals(planId))).getSingle();
    });
  }

  Future<GeneratedPlan?> latestPlan(int profileId) =>
      (_database.select(_database.generatedPlans)
            ..where((row) => row.userProfileId.equals(profileId))
            ..orderBy([(row) => OrderingTerm.desc(row.version)])
            ..limit(1))
          .getSingleOrNull();

  Future<GeneratedPlan?> activePlan(int profileId) =>
      (_database.select(_database.generatedPlans)
            ..where(
              (row) =>
                  row.userProfileId.equals(profileId) &
                  row.isActive.equals(true),
            )
            ..orderBy([(row) => OrderingTerm.desc(row.version)])
            ..limit(1))
          .getSingleOrNull();

  Future<void> setActivePlan({
    required int profileId,
    required int planId,
  }) async {
    final current = await activePlan(profileId);
    final selected = await findByIdForProfile(planId, profileId);
    if (selected == null || selected.id == current?.id) return;
    await _database.transaction(() async {
      await (_database.update(_database.generatedPlans)
            ..where((row) => row.userProfileId.equals(profileId)))
          .write(const GeneratedPlansCompanion(isActive: Value(false)));
      await (_database.update(_database.generatedPlans)..where(
            (row) =>
                row.id.equals(planId) & row.userProfileId.equals(profileId),
          ))
          .write(const GeneratedPlansCompanion(isActive: Value(true)));
    });
    final queue = SyncQueueRepository(_database);
    final changedAt = DateTime.now().toUtc();
    if (current != null) {
      await queue.enqueue(
        entityTable: 'GeneratedPlans',
        entityId: current.id,
        operation: 'update',
        payload: _planPayload(current, isActive: false),
        dirtyAt: changedAt,
      );
    }
    await queue.enqueue(
      entityTable: 'GeneratedPlans',
      entityId: selected.id,
      operation: 'update',
      payload: _planPayload(selected, isActive: true),
      dirtyAt: changedAt,
    );
  }

  Future<List<GeneratedPlan>> history(int profileId) =>
      (_database.select(_database.generatedPlans)
            ..where((row) => row.userProfileId.equals(profileId))
            ..orderBy([(row) => OrderingTerm.desc(row.version)]))
          .get();

  Future<GeneratedPlan?> findById(int planId) => (_database.select(
    _database.generatedPlans,
  )..where((row) => row.id.equals(planId))).getSingleOrNull();

  Future<GeneratedPlan?> findByIdForProfile(int planId, int profileId) =>
      (_database.select(_database.generatedPlans)..where(
            (row) =>
                row.id.equals(planId) & row.userProfileId.equals(profileId),
          ))
          .getSingleOrNull();

  Future<List<MealSlot>> slotsForPlan(int planId) =>
      (_database.select(_database.mealSlots)
            ..where((row) => row.generatedPlanId.equals(planId))
            ..orderBy([
              (row) => OrderingTerm.asc(row.dayIndex),
              (row) => OrderingTerm.asc(row.slotIndex),
            ]))
          .get();

  Future<void> updateMealSlot({
    required int profileId,
    required int slotId,
    required String mealStatus,
    required DateTime? consumedAt,
    int? actualCostCents,
    String? substituteName,
  }) async {
    const validStatuses = {'planned', 'eaten', 'substitute', 'skipped'};
    if (!validStatuses.contains(mealStatus)) {
      throw ArgumentError.value(mealStatus, 'mealStatus');
    }
    if (mealStatus == 'substitute' &&
        (actualCostCents == null ||
            actualCostCents < 0 ||
            substituteName?.trim().isEmpty != false)) {
      throw ArgumentError('Substitute meals require a name and actual cost.');
    }
    if (mealStatus == 'skipped' &&
        (actualCostCents != null || substituteName != null)) {
      throw ArgumentError('Skipped meals cannot have substitute details.');
    }
    final slot = await (_database.select(
      _database.mealSlots,
    )..where((row) => row.id.equals(slotId))).getSingleOrNull();
    if (slot == null) return;
    final plan = await findByIdForProfile(slot.generatedPlanId, profileId);
    if (plan == null) return;
    await (_database.update(
      _database.mealSlots,
    )..where((row) => row.id.equals(slotId))).write(
      MealSlotsCompanion(
        mealStatus: Value(mealStatus),
        actualCostCents: Value(actualCostCents),
        substituteName: Value(substituteName),
        consumedAt: Value(consumedAt?.toUtc()),
      ),
    );
    await SyncQueueRepository(_database).enqueue(
      entityTable: 'MealSlots',
      entityId: slotId,
      operation: 'update',
      payload: {
        'profile_id': profileId,
        'generated_plan_id': slot.generatedPlanId,
        'dish_id': slot.dishId,
        'day_index': slot.dayIndex,
        'slot_index': slot.slotIndex,
        'planned_cost_cents': slot.plannedCostCents,
        'planned_calories': slot.plannedCalories,
        'meal_status': mealStatus,
        'actual_cost_cents': actualCostCents,
        'substitute_name': substituteName,
        'consumed_at': consumedAt?.toUtc().toIso8601String(),
      },
    );
  }

  Future<GeneratedMealPlan> loadMealPlan(GeneratedPlan plan) async {
    final dishDao = DishDao(_database);
    final slots = await slotsForPlan(plan.id);
    final assignments = <MealSlotAssignment>[];
    for (final slot in slots) {
      final dish = await dishDao.findById(slot.dishId);
      if (dish == null) continue;
      final ingredients = await dishDao.ingredientsForDish(dish.id);
      assignments.add(
        MealSlotAssignment(
          dayIndex: slot.dayIndex,
          slotIndex: slot.slotIndex,
          dish: PlannerDish(
            id: dish.id,
            name: dish.name,
            price: dish.priceCents / 100,
            calories: ingredients.fold(0, (sum, item) => sum + item.calories),
            proteinG: ingredients.fold(0, (sum, item) => sum + item.proteinG),
            carbsG: ingredients.fold(0, (sum, item) => sum + item.carbsG),
            fatG: ingredients.fold(0, (sum, item) => sum + item.fatG),
            ingredients: ingredients.map((item) => item.name).toList(),
          ),
          reason: 'saved active plan',
        ),
      );
    }
    return GeneratedMealPlan(
      assignments: assignments,
      totalCostCents: plan.totalProjectedCostCents,
      isOverBudget: plan.isOverBudget,
    );
  }

  Map<String, dynamic> _planPayload(
    GeneratedPlan plan, {
    required bool isActive,
  }) => {
    'profile_id': plan.userProfileId,
    'week_start_date': plan.weekStartDate.toUtc().toIso8601String(),
    'generated_at': plan.generatedAt.toUtc().toIso8601String(),
    'total_projected_cost_cents': plan.totalProjectedCostCents,
    'is_over_budget': plan.isOverBudget,
    'version': plan.version,
    'is_active': isActive,
    'planning_focus': plan.planningFocus,
    'currency_code': plan.currencyCode,
  };
}
