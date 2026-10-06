import '../../nutrition_goal/domain/nutrition_models.dart';

enum PlanningFocus {
  balanced('Balanced', 'A practical mix of cost, nutrition, and variety.'),
  budget('Budget first', 'Minimize cost while staying nutritionally useful.'),
  highProtein('High protein', 'Prioritize protein-rich dishes.'),
  variety('Maximum variety', 'Spread choices across your library.'),
  quick('Simple rotation', 'Favor a small, repeatable set of easy meals.');

  const PlanningFocus(this.label, this.description);

  final String label;
  final String description;
}

class PlannerDish {
  const PlannerDish({
    required this.id,
    required this.name,
    required this.price,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.ingredients = const [],
  });

  final int id;
  final String name;
  final double price;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final List<String> ingredients;

  int get roundedPriceCents => (price * 100).round();

  NutritionTargets get nutrition => NutritionTargets(
    calories: calories,
    proteinG: proteinG,
    carbsG: carbsG,
    fatG: fatG,
  );
}

class MealSlotAssignment {
  const MealSlotAssignment({
    required this.dayIndex,
    required this.slotIndex,
    required this.dish,
    required this.reason,
    this.servings = 1,
  });

  final int dayIndex;
  final int slotIndex;
  final PlannerDish dish;
  final String reason;
  final double servings;

  NutritionTargets get nutrition => dish.nutrition * servings;

  int get plannedCostCents => (dish.roundedPriceCents * servings).round();

  MealSlotAssignment copyWith({
    PlannerDish? dish,
    String? reason,
    double? servings,
  }) => MealSlotAssignment(
    dayIndex: dayIndex,
    slotIndex: slotIndex,
    dish: dish ?? this.dish,
    reason: reason ?? this.reason,
    servings: servings ?? this.servings,
  );
}

class GeneratedMealPlan {
  const GeneratedMealPlan({
    required this.assignments,
    required this.totalCostCents,
    required this.isOverBudget,
  });

  final List<MealSlotAssignment> assignments;
  final int totalCostCents;
  final bool isOverBudget;

  GeneratedMealPlan copyWith({
    List<MealSlotAssignment>? assignments,
    int? totalCostCents,
    bool? isOverBudget,
  }) => GeneratedMealPlan(
    assignments: assignments ?? this.assignments,
    totalCostCents: totalCostCents ?? this.totalCostCents,
    isOverBudget: isOverBudget ?? this.isOverBudget,
  );
}

class PlanNutritionSummary {
  const PlanNutritionSummary({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  factory PlanNutritionSummary.fromAssignments(
    Iterable<MealSlotAssignment> assignments,
  ) {
    return assignments.fold(
      const PlanNutritionSummary(calories: 0, proteinG: 0, carbsG: 0, fatG: 0),
      (total, assignment) => PlanNutritionSummary(
        calories: total.calories + assignment.nutrition.calories,
        proteinG: total.proteinG + assignment.nutrition.proteinG,
        carbsG: total.carbsG + assignment.nutrition.carbsG,
        fatG: total.fatG + assignment.nutrition.fatG,
      ),
    );
  }
}
