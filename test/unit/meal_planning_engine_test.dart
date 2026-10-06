import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/features/meal_planner/domain/meal_planning_engine.dart';
import 'package:nutriwallet/features/meal_planner/domain/planner_models.dart';
import 'package:nutriwallet/features/nutrition_goal/domain/nutrition_models.dart';

void main() {
  final target = const NutritionTargets(
    calories: 1800,
    proteinG: 120,
    carbsG: 180,
    fatG: 60,
  );
  final dishes = [
    const PlannerDish(
      id: 1,
      name: 'Chicken rice',
      price: 2.005,
      calories: 500,
      proteinG: 35,
      carbsG: 55,
      fatG: 12,
      ingredients: ['chicken'],
    ),
    const PlannerDish(
      id: 2,
      name: 'Bean bowl',
      price: 1.50,
      calories: 450,
      proteinG: 20,
      carbsG: 70,
      fatG: 8,
      ingredients: ['beans'],
    ),
    const PlannerDish(
      id: 3,
      name: 'Salmon potato',
      price: 3.00,
      calories: 550,
      proteinG: 38,
      carbsG: 40,
      fatG: 20,
      ingredients: ['salmon'],
    ),
    const PlannerDish(
      id: 4,
      name: 'Tofu greens',
      price: 1.25,
      calories: 350,
      proteinG: 28,
      carbsG: 20,
      fatG: 14,
      ingredients: ['tofu'],
    ),
  ];

  test(
    'generates an affordable plan and applies currency rounding before totals',
    () {
      final result = const MealPlanningEngine().generateWeeklyPlan(
        dishes: dishes,
        budgetCents: 606,
        nutritionTargets: target,
        exclusions: {},
        days: [1, 2, 3],
        mealsPerDay: 1,
      );

      expect(result.assignments, hasLength(3));
      expect(result.totalCostCents, lessThanOrEqualTo(606));
      expect(
        result.totalCostCents,
        result.assignments.fold<int>(
          0,
          (sum, item) => sum + item.dish.roundedPriceCents,
        ),
      );
      expect(result.isOverBudget, isFalse);
    },
  );

  test(
    'regeneration under a lower budget never presents an over-budget plan',
    () {
      const engine = MealPlanningEngine();
      final initial = engine.generateWeeklyPlan(
        dishes: dishes,
        budgetCents: 1200,
        nutritionTargets: target,
        exclusions: {},
        days: [1, 2, 3, 4, 5, 6, 7],
        mealsPerDay: 1,
      );
      final regenerated = engine.generateWeeklyPlan(
        dishes: dishes,
        budgetCents: 400,
        nutritionTargets: target,
        exclusions: {},
        days: [1, 2, 3, 4, 5, 6, 7],
        mealsPerDay: 1,
      );

      expect(initial.totalCostCents, greaterThan(400));
      expect(regenerated.totalCostCents, lessThanOrEqualTo(400));
      expect(regenerated.isOverBudget, isFalse);
    },
  );

  test('exclusions are a hard pre-filter and never appear in assignments', () {
    final result = const MealPlanningEngine().generateWeeklyPlan(
      dishes: dishes,
      budgetCents: 1000,
      nutritionTargets: target,
      exclusions: {'chicken', 'salmon'},
      days: [1, 2, 3, 4],
      mealsPerDay: 1,
    );

    expect(
      result.assignments.every(
        (item) => !item.dish.ingredients.contains('chicken'),
      ),
      isTrue,
    );
    expect(
      result.assignments.every(
        (item) => !item.dish.ingredients.contains('salmon'),
      ),
      isTrue,
    );
  });

  test('avoids consecutive repeats when another affordable dish exists', () {
    final result = const MealPlanningEngine().generateWeeklyPlan(
      dishes: dishes,
      budgetCents: 2000,
      nutritionTargets: target,
      exclusions: {},
      days: [1, 2, 3, 4, 5, 6, 7],
      mealsPerDay: 1,
    );

    for (var index = 1; index < result.assignments.length; index++) {
      expect(
        result.assignments[index].dish.id,
        isNot(result.assignments[index - 1].dish.id),
      );
    }
  });

  test('simple rotation focus prefers a compact dish set', () {
    final result = const MealPlanningEngine().generateWeeklyPlan(
      dishes: dishes,
      budgetCents: 2000,
      nutritionTargets: target,
      exclusions: {},
      days: [1, 2, 3, 4, 5, 6, 7],
      mealsPerDay: 1,
      focus: PlanningFocus.quick,
    );

    expect(
      result.assignments.map((item) => item.dish.id).toSet().length,
      lessThanOrEqualTo(3),
    );
  });
}
