enum Sex { male, female }

enum ActivityLevel {
  sedentary(1.2),
  light(1.375),
  moderate(1.55),
  active(1.725),
  veryActive(1.9);

  const ActivityLevel(this.multiplier);

  final double multiplier;
}

enum GoalPreset {
  balanced(1, 0.30, 0.40, 0.30),
  cutting(0.80, 0.35, 0.35, 0.30),
  bulking(1.15, 0.30, 0.45, 0.25),
  highProtein(1, 0.40, 0.30, 0.30),
  keto(1, 0.25, 0.05, 0.70);

  const GoalPreset(
    this.calorieFactor,
    this.proteinRatio,
    this.carbsRatio,
    this.fatRatio,
  );

  final double calorieFactor;
  final double proteinRatio;
  final double carbsRatio;
  final double fatRatio;
}

class NutritionTargets {
  const NutritionTargets({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  NutritionTargets operator *(double factor) => NutritionTargets(
    calories: calories * factor,
    proteinG: proteinG * factor,
    carbsG: carbsG * factor,
    fatG: fatG * factor,
  );
}

class NutritionCalculator {
  const NutritionCalculator._();

  static double bmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required Sex sex,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    return base + (sex == Sex.male ? 5 : -161);
  }

  static double tdee({
    required double weightKg,
    required double heightCm,
    required int age,
    required Sex sex,
    required ActivityLevel activityLevel,
  }) {
    return bmr(weightKg: weightKg, heightCm: heightCm, age: age, sex: sex) *
        activityLevel.multiplier;
  }

  static double bmi({required double weightKg, required double heightCm}) {
    final heightM = heightCm / 100;
    if (heightM <= 0) return 0;
    return weightKg / (heightM * heightM);
  }

  static NutritionTargets targetsFor({
    required double tdee,
    required GoalPreset preset,
  }) {
    final calories = tdee * preset.calorieFactor;
    return NutritionTargets(
      calories: calories,
      proteinG: calories * preset.proteinRatio / 4,
      carbsG: calories * preset.carbsRatio / 4,
      fatG: calories * preset.fatRatio / 9,
    );
  }
}
