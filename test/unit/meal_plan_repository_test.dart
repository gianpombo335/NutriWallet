import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';

import 'package:nutriwallet/data/local/daos/dish_dao.dart';
import 'package:nutriwallet/data/local/daos/profile_dao.dart';
import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/repositories/meal_plan_repository.dart';
import 'package:nutriwallet/data/repositories/budget_repository.dart';
import 'package:nutriwallet/features/meal_planner/domain/planner_models.dart';

void main() {
  test('generated plans are persisted as versioned history', () async {
    final database = AppDatabase();
    addTearDown(database.close);
    final profileId = await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'plans@example.com',
        weeklyBudgetCents: const Value(1000),
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final dishId = await DishDao(database).insertDish(
      DishesCompanion.insert(
        userProfileId: profileId,
        name: 'Rice bowl',
        priceCents: 500,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final dish = PlannerDish(
      id: dishId,
      name: 'Rice bowl',
      price: 5,
      calories: 400,
      proteinG: 20,
      carbsG: 50,
      fatG: 10,
    );
    final plan = GeneratedMealPlan(
      assignments: [
        MealSlotAssignment(
          dayIndex: 1,
          slotIndex: 0,
          dish: dish,
          reason: 'fits budget',
        ),
      ],
      totalCostCents: 500,
      isOverBudget: false,
    );
    final repository = MealPlanRepository(database);

    await repository.savePlan(
      profileId: profileId,
      weekStartDate: DateTime.utc(2026, 1, 5),
      plan: plan,
      planningFocus: 'budget',
      currencyCode: 'PHP',
    );
    final firstQueue = await database.select(database.syncQueue).get();
    expect(firstQueue.map((item) => item.entityTable), [
      'GeneratedPlans',
      'MealSlots',
    ]);
    final slotPayload =
        jsonDecode(firstQueue[1].payloadJson) as Map<String, dynamic>;
    expect(slotPayload['generated_plan_id'], 1);
    await repository.savePlan(
      profileId: profileId,
      weekStartDate: DateTime.utc(2026, 1, 5),
      plan: plan,
      planningFocus: 'budget',
      currencyCode: 'PHP',
    );

    final rows = await database.select(database.generatedPlans).get();
    final latest = await repository.latestPlan(profileId);
    expect(rows.map((row) => row.version), containsAll([1, 2]));
    expect(latest?.version, 2);
    expect((await repository.activePlan(profileId))?.version, 2);
    expect(latest?.planningFocus, 'budget');
    expect(latest?.currencyCode, 'PHP');
    expect(await database.select(database.mealSlots).get(), hasLength(2));
    expect((await repository.history(profileId)).map((plan) => plan.version), [
      2,
      1,
    ]);
    expect((await repository.slotsForPlan(latest!.id)).single.dayIndex, 1);

    await repository.setActivePlan(profileId: profileId, planId: rows.first.id);
    expect((await repository.activePlan(profileId))?.version, 1);

    final slot = (await repository.slotsForPlan(rows.first.id)).single;
    await repository.updateMealSlot(
      profileId: profileId,
      slotId: slot.id,
      mealStatus: 'substitute',
      consumedAt: DateTime.utc(2026, 1, 5),
      actualCostCents: 750,
      substituteName: 'Noodle bowl',
    );
    final updatedSlot = (await repository.slotsForPlan(rows.first.id)).single;
    expect(updatedSlot.mealStatus, 'substitute');
    expect(updatedSlot.actualCostCents, 750);
    expect(updatedSlot.substituteName, 'Noodle bowl');

    final budget = BudgetRepository(database);
    await budget.upsertMealSlotExpense(
      profileId: profileId,
      mealSlotId: slot.id,
      amountCents: 750,
      label: 'Substitute meal: Noodle bowl',
      occurredAt: DateTime.utc(2026, 1, 5),
      generatedPlanId: rows.first.id,
    );
    await budget.upsertMealSlotExpense(
      profileId: profileId,
      mealSlotId: slot.id,
      amountCents: 900,
      label: 'Substitute meal: Updated bowl',
      occurredAt: DateTime.utc(2026, 1, 5),
      generatedPlanId: rows.first.id,
    );
    final expenses = await budget.watchEntries(profileId).first;
    expect(expenses, hasLength(1));
    expect(expenses.single.amountCents, 900);
  });
}
