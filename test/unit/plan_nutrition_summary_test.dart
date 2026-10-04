import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/features/meal_planner/domain/planner_models.dart';

void main() {
  test('aggregates calories and macros for a generated plan', () {
    const first = PlannerDish(
      id: 1,
      name: 'Bowl',
      price: 2,
      calories: 400,
      proteinG: 30,
      carbsG: 50,
      fatG: 10,
    );
    const second = PlannerDish(
      id: 2,
      name: 'Toast',
      price: 1,
      calories: 200,
      proteinG: 8,
      carbsG: 30,
      fatG: 4,
    );
    const assignments = [
      MealSlotAssignment(dayIndex: 1, slotIndex: 0, dish: first, reason: 'fit'),
      MealSlotAssignment(
        dayIndex: 1,
        slotIndex: 1,
        dish: second,
        reason: 'fit',
      ),
    ];

    final summary = PlanNutritionSummary.fromAssignments(assignments);

    expect(summary.calories, 600);
    expect(summary.proteinG, 38);
    expect(summary.carbsG, 80);
    expect(summary.fatG, 14);
  });
}
