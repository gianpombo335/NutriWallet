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
                plannedCostCents: assignment.plannedCostCents,
                plannedCalories: Value(assignment.nutrition.calories),
                plannedProteinG: Value(assignment.nutrition.proteinG),
                plannedCarbsG: Value(assignment.nutrition.carbsG),
                plannedFatG: Value(assignment.nutrition.fatG),
                servings: Value(assignment.servings),
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
            'planned_cost_cents': assignment.plannedCostCents,
            'planned_calories': assignment.nutrition.calories,
            'planned_protein_g': assignment.nutrition.proteinG,
            'planned_carbs_g': assignment.nutrition.carbsG,
            'planned_fat_g': assignment.nutrition.fatG,
            'servings': assignment.servings,
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

  Future<void> updateMealSlotPlan({
    required int profileId,
    required int planId,
    required int dayIndex,
    required int slotIndex,
    required PlannerDish dish,
    required double servings,
  }) async {
    if (!servings.isFinite || servings < 0.5) {
      throw ArgumentError.value(servings, 'servings');
    }
    final plan = await findByIdForProfile(planId, profileId);
    if (plan == null) return;
    final savedDish = await DishDao(_database).findById(dish.id);
    if (savedDish == null || savedDish.userProfileId != profileId) return;
    final slot =
        await (_database.select(_database.mealSlots)..where(
              (row) =>
                  row.generatedPlanId.equals(planId) &
                  row.dayIndex.equals(dayIndex) &
                  row.slotIndex.equals(slotIndex),
            ))
            .getSingleOrNull();
    if (slot == null) return;

    final scaledNutrition = dish.nutrition * servings;
    final plannedCostCents = (dish.roundedPriceCents * servings).round();
    final changedAt = DateTime.now().toUtc();
    await _database.transaction(() async {
      await (_database.update(
        _database.mealSlots,
      )..where((row) => row.id.equals(slot.id))).write(
        MealSlotsCompanion(
          dishId: Value(dish.id),
          plannedCostCents: Value(plannedCostCents),
          plannedCalories: Value(scaledNutrition.calories),
          plannedProteinG: Value(scaledNutrition.proteinG),
          plannedCarbsG: Value(scaledNutrition.carbsG),
          plannedFatG: Value(scaledNutrition.fatG),
          servings: Value(servings),
        ),
      );

      final updatedSlots = await slotsForPlan(planId);
      final totalCostCents = updatedSlots.fold<int>(
        0,
        (sum, item) => sum + item.plannedCostCents,
      );
      final profile = await (_database.select(
        _database.userProfiles,
      )..where((row) => row.id.equals(profileId))).getSingle();
      final isOverBudget = totalCostCents > profile.weeklyBudgetCents;
      await (_database.update(_database.generatedPlans)..where(
            (row) =>
                row.id.equals(planId) & row.userProfileId.equals(profileId),
          ))
          .write(
            GeneratedPlansCompanion(
              totalProjectedCostCents: Value(totalCostCents),
              isOverBudget: Value(isOverBudget),
            ),
          );

      final queue = SyncQueueRepository(_database);
      await queue.enqueue(
        entityTable: 'MealSlots',
        entityId: slot.id,
        operation: 'update',
        payload: {
          'profile_id': profileId,
          'generated_plan_id': planId,
          'dish_id': dish.id,
          'day_index': slot.dayIndex,
          'slot_index': slot.slotIndex,
          'planned_cost_cents': plannedCostCents,
          'planned_calories': scaledNutrition.calories,
          'planned_protein_g': scaledNutrition.proteinG,
          'planned_carbs_g': scaledNutrition.carbsG,
          'planned_fat_g': scaledNutrition.fatG,
          'servings': servings,
          'plan_edit': true,
          'meal_status': slot.mealStatus,
        },
        dirtyAt: changedAt,
      );
      await queue.enqueue(
        entityTable: 'GeneratedPlans',
        entityId: planId,
        operation: 'update',
        payload: _planPayload(
          plan,
          totalCostCents: totalCostCents,
          isOverBudget: isOverBudget,
        ),
        dirtyAt: changedAt,
      );
    });
  }

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
    if (mealStatus == 'eaten' &&
        (actualCostCents == null || actualCostCents < 0)) {
      throw ArgumentError('Eaten meals require a non-negative actual cost.');
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
        'planned_protein_g': slot.plannedProteinG,
        'planned_carbs_g': slot.plannedCarbsG,
        'planned_fat_g': slot.plannedFatG,
        'servings': slot.servings,
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
      final servings = slot.servings <= 0 ? 1.0 : slot.servings;
      assignments.add(
        MealSlotAssignment(
          dayIndex: slot.dayIndex,
          slotIndex: slot.slotIndex,
          dish: PlannerDish(
            id: dish.id,
            name: dish.name,
            // Saved slots are snapshots. A later dish edit should not silently
            // rewrite the historical plan's nutrition or projected cost.
            price: slot.plannedCostCents / servings / 100,
            calories: slot.plannedCalories / servings,
            proteinG: slot.plannedProteinG / servings,
            carbsG: slot.plannedCarbsG / servings,
            fatG: slot.plannedFatG / servings,
            ingredients: ingredients.map((item) => item.name).toList(),
          ),
          reason: 'saved active plan',
          servings: servings,
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
    bool? isActive,
    int? totalCostCents,
    bool? isOverBudget,
  }) => {
    'profile_id': plan.userProfileId,
    'week_start_date': plan.weekStartDate.toUtc().toIso8601String(),
    'generated_at': plan.generatedAt.toUtc().toIso8601String(),
    'total_projected_cost_cents':
        totalCostCents ?? plan.totalProjectedCostCents,
    'is_over_budget': isOverBudget ?? plan.isOverBudget,
    'version': plan.version,
    'is_active': isActive ?? plan.isActive,
    'planning_focus': plan.planningFocus,
    'currency_code': plan.currencyCode,
  };
}
