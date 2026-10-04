import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/data/remote/smart_plan_service.dart';
import 'package:nutriwallet/features/meal_planner/domain/planner_models.dart';

void main() {
  final dishes = [
    const PlannerDish(
      id: 1,
      name: 'Chicken bowl',
      price: 4,
      calories: 500,
      proteinG: 35,
      carbsG: 45,
      fatG: 12,
      ingredients: ['chicken'],
    ),
    const PlannerDish(
      id: 2,
      name: 'Bean bowl',
      price: 3,
      calories: 450,
      proteinG: 20,
      carbsG: 55,
      fatG: 8,
      ingredients: ['beans'],
    ),
  ];

  test('accepts an exact valid Gemini recommendation', () {
    expect(
      validateGeminiDishIds(
        rawIds: [1, 2, 1],
        dishes: dishes,
        expectedSlots: 3,
        exclusions: const {},
      ),
      [1, 2, 1],
    );
  });

  test('rejects malformed, unknown, and excluded Gemini output', () {
    expect(
      validateGeminiDishIds(
        rawIds: [1, 'bad'],
        dishes: dishes,
        expectedSlots: 2,
        exclusions: const {},
      ),
      isEmpty,
    );
    expect(
      validateGeminiDishIds(
        rawIds: [1, 99],
        dishes: dishes,
        expectedSlots: 2,
        exclusions: const {},
      ),
      isEmpty,
    );
    expect(
      validateGeminiDishIds(
        rawIds: [1],
        dishes: dishes,
        expectedSlots: 1,
        exclusions: {'chicken'},
      ),
      isEmpty,
    );
  });
}
