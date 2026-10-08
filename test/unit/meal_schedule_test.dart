import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';

import 'package:nutriwallet/data/local/daos/profile_dao.dart';
import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/repositories/meal_plan_repository.dart';
import 'package:nutriwallet/features/meal_planner/domain/meal_schedule.dart';
import 'package:nutriwallet/features/meal_planner/domain/planner_models.dart';

void main() {
  test('meal schedule defaults match the selected meal count', () {
    expect(MealSchedule.forMealsPerDay(2).minutesAfterMidnight, [480, 1140]);
    expect(MealSchedule.forMealsPerDay(5).minutesAfterMidnight, [
      420,
      600,
      780,
      960,
      1140,
    ]);
  });

  test('resolver identifies the current and next unchecked meals', () async {
    final database = AppDatabase();
    addTearDown(database.close);
    final profileId = await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'schedule@example.com',
        mealsPerDay: const Value(3),
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final dishId = await database
        .into(database.dishes)
        .insert(
          DishesCompanion.insert(
            userProfileId: profileId,
            name: 'Scheduled bowl',
            priceCents: 300,
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
          ),
        );
    final repository = MealPlanRepository(database);
    final plan = await repository.savePlan(
      profileId: profileId,
      weekStartDate: DateTime.utc(2026, 1, 5),
      plan: GeneratedMealPlan(
        assignments: [
          for (var index = 0; index < 3; index++)
            MealSlotAssignment(
              dayIndex: 1,
              slotIndex: index,
              dish: PlannerDish(
                id: dishId,
                name: 'Scheduled bowl',
                price: 3,
                calories: 400,
                proteinG: 20,
                carbsG: 40,
                fatG: 10,
              ),
              reason: 'fit',
            ),
        ],
        totalCostCents: 900,
        isOverBudget: false,
      ),
    );
    final slots = await repository.slotsForPlan(plan.id);
    final meals = MealScheduleResolver.resolve(
      plan: plan,
      slots: slots,
      schedule: MealSchedule.forMealsPerDay(3),
    );
    final now = DateTime(2026, 1, 5, 10);
    expect(
      MealScheduleResolver.currentMeal(meals, now: now)?.slot.slotIndex,
      0,
    );
    expect(MealScheduleResolver.nextMeal(meals, now: now)?.slot.slotIndex, 1);
    expect(
      MealScheduleResolver.mealsToAutoSkip(
        meals,
        now: DateTime(2026, 1, 5, 11, 59),
      ),
      isEmpty,
    );
    expect(
      MealScheduleResolver.mealsToAutoSkip(
        meals,
        now: DateTime(2026, 1, 5, 12),
      ).map((meal) => meal.slot.slotIndex),
      [0],
    );
  });

  test('slot stream reflects meal check-in status changes', () async {
    final database = AppDatabase();
    addTearDown(database.close);
    final profileId = await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'stream@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final dishId = await database
        .into(database.dishes)
        .insert(
          DishesCompanion.insert(
            userProfileId: profileId,
            name: 'Stream bowl',
            priceCents: 300,
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
          ),
        );
    final repository = MealPlanRepository(database);
    final plan = await repository.savePlan(
      profileId: profileId,
      weekStartDate: DateTime.utc(2026, 1, 5),
      plan: GeneratedMealPlan(
        assignments: [
          MealSlotAssignment(
            dayIndex: 1,
            slotIndex: 0,
            dish: PlannerDish(
              id: dishId,
              name: 'Stream bowl',
              price: 3,
              calories: 400,
              proteinG: 20,
              carbsG: 40,
              fatG: 10,
            ),
            reason: 'test',
          ),
        ],
        totalCostCents: 300,
        isOverBudget: false,
      ),
    );
    final stream = repository.watchSlotsForPlan(plan.id);
    expect((await stream.first).single.mealStatus, 'planned');

    await repository.updateMealSlot(
      profileId: profileId,
      slotId: (await repository.slotsForPlan(plan.id)).single.id,
      mealStatus: 'skipped',
      consumedAt: DateTime.utc(2026, 1, 5),
    );

    expect((await stream.first).single.mealStatus, 'skipped');
  });
}
