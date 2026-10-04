import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/features/nutrition_goal/domain/nutrition_models.dart';

void main() {
  test('calculates Mifflin-St Jeor BMR for a man', () {
    final result = NutritionCalculator.bmr(
      weightKg: 80,
      heightCm: 180,
      age: 30,
      sex: Sex.male,
    );

    expect(result, closeTo(1780, 0.001));
  });

  test('calculates TDEE using the selected activity multiplier', () {
    final result = NutritionCalculator.tdee(
      weightKg: 80,
      heightCm: 180,
      age: 30,
      sex: Sex.male,
      activityLevel: ActivityLevel.moderate,
    );

    expect(result, closeTo(2759, 0.1));
  });

  test('calculates BMI and goal macro targets', () {
    expect(
      NutritionCalculator.bmi(weightKg: 80, heightCm: 180),
      closeTo(24.691, 0.001),
    );
    final targets = NutritionCalculator.targetsFor(
      tdee: 2000,
      preset: GoalPreset.keto,
    );
    expect(targets.calories, 2000);
    expect(targets.proteinG, closeTo(125, 0.001));
    expect(targets.carbsG, closeTo(25, 0.001));
    expect(targets.fatG, closeTo(155.555, 0.001));
  });
}
