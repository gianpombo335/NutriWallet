import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/core/currency/app_currency.dart';
import 'package:nutriwallet/data/local/daos/profile_dao.dart';
import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/repositories/meal_plan_repository.dart';
import 'package:nutriwallet/features/meal_planner/domain/meal_schedule.dart';
import 'package:nutriwallet/features/meal_planner/meal_check_in.dart';
import 'package:nutriwallet/features/meal_planner/domain/planner_models.dart';

void main() {
  testWidgets('dashboard shows the current meal and quick outcomes', (
    tester,
  ) async {
    final database = AppDatabase();
    addTearDown(database.close);
    final profileId = await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'dashboard@example.com',
        mealsPerDay: const Value(1),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    final dishId = await database
        .into(database.dishes)
        .insert(
          DishesCompanion.insert(
            userProfileId: profileId,
            name: 'Dashboard bowl',
            priceCents: 450,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
    final dish = PlannerDish(
      id: dishId,
      name: 'Dashboard bowl',
      price: 4.5,
      calories: 450,
      proteinG: 25,
      carbsG: 40,
      fatG: 12,
    );
    final repository = MealPlanRepository(database);
    final plan = await repository.savePlan(
      profileId: profileId,
      weekStartDate: _monday(DateTime.now()),
      plan: GeneratedMealPlan(
        assignments: [
          MealSlotAssignment(
            dayIndex: DateTime.now().weekday,
            slotIndex: 0,
            dish: dish,
            reason: 'test',
          ),
        ],
        totalCostCents: 450,
        isOverBudget: false,
      ),
    );
    final slots = await repository.slotsForPlan(plan.id);
    final actions = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MealStatusDashboard(
            plan: plan,
            slots: slots,
            schedule: const MealSchedule([0]),
            currency: currencyForCode('USD'),
            mealTitle: (_) => 'Dashboard bowl',
            onQuickAction: (_, status) async => actions.add(status),
            onMoreActions: (_) async => actions.add('more'),
            onAutoSkip: (_) async {},
          ),
        ),
      ),
    );

    expect(find.text('Current meal'), findsOneWidget);
    expect(find.text('Dashboard bowl'), findsOneWidget);
    expect(find.text('Eaten'), findsOneWidget);
    expect(find.text('Substitute'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    expect(actions, ['skipped']);
  });
}

DateTime _monday(DateTime value) =>
    DateTime.utc(value.year, value.month, value.day - (value.weekday - 1));
