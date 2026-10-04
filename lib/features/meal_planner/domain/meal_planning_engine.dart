import '../../nutrition_goal/domain/nutrition_models.dart';
import 'planner_models.dart';

class MealPlanningEngine {
  const MealPlanningEngine({this.maxRefinementIterations = 4});

  final int maxRefinementIterations;

  GeneratedMealPlan generateWeeklyPlan({
    required List<PlannerDish> dishes,
    required int budgetCents,
    required NutritionTargets nutritionTargets,
    required Set<String> exclusions,
    required List<int> days,
    required int mealsPerDay,
    PlanningFocus focus = PlanningFocus.balanced,
    List<int> preferredDishIds = const [],
  }) {
    final candidates = dishes
        .where((dish) => !_isExcluded(dish, exclusions))
        .toList(growable: false);
    final assignments = <MealSlotAssignment>[];
    var remainingBudget = budgetCents;
    var remainingTargets = nutritionTargets;
    final usedCounts = <int, int>{};

    for (final day in days) {
      for (var slot = 0; slot < mealsPerDay; slot++) {
        final affordable = candidates
            .where((dish) => dish.roundedPriceCents <= remainingBudget)
            .toList();
        if (affordable.isEmpty) break;
        final previousDishId = assignments.isEmpty
            ? null
            : assignments.last.dish.id;
        final varied = affordable
            .where((dish) => dish.id != previousDishId)
            .toList();
        final pool = varied.isEmpty ? affordable : varied;
        final ranked =
            pool
                .map(
                  (dish) => (
                    dish: dish,
                    score: _greedyScore(
                      dish,
                      remainingTargets,
                      remainingBudget,
                      usedCounts[dish.id] ?? 0,
                      focus,
                      preferredDishIds,
                    ),
                  ),
                )
                .toList()
              ..sort((a, b) => b.score.compareTo(a.score));
        final chosen = ranked.first.dish;
        assignments.add(
          MealSlotAssignment(
            dayIndex: day,
            slotIndex: slot,
            dish: chosen,
            reason: _reasonFor(chosen, remainingBudget, nutritionTargets),
          ),
        );
        remainingBudget -= chosen.roundedPriceCents;
        remainingTargets = _subtract(remainingTargets, chosen.nutrition);
        usedCounts.update(chosen.id, (count) => count + 1, ifAbsent: () => 1);
      }
    }

    _refine(assignments, candidates, budgetCents, nutritionTargets);
    final totalCost = assignments.fold<int>(
      0,
      (sum, item) => sum + item.dish.roundedPriceCents,
    );
    return GeneratedMealPlan(
      assignments: List.unmodifiable(assignments),
      totalCostCents: totalCost,
      isOverBudget: totalCost > budgetCents,
    );
  }

  bool _isExcluded(PlannerDish dish, Set<String> exclusions) {
    final searchable = <String>[
      dish.name,
      ...dish.ingredients,
    ].join(' ').toLowerCase();
    return exclusions.any(
      (exclusion) =>
          exclusion.trim().isNotEmpty &&
          searchable.contains(exclusion.trim().toLowerCase()),
    );
  }

  double _greedyScore(
    PlannerDish dish,
    NutritionTargets remaining,
    int budget,
    int usedCount,
    PlanningFocus focus,
    List<int> preferredDishIds,
  ) {
    final fit = _fitScore(dish.nutrition, remaining);
    final value =
        (dish.proteinG * 4 + dish.carbsG * 2 + dish.fatG) /
        dish.roundedPriceCents.clamp(1, 1 << 30);
    final budgetSafety =
        1 - (dish.roundedPriceCents / budget.clamp(1, 1 << 30));
    final focusBonus = switch (focus) {
      PlanningFocus.budget => budgetSafety * 2,
      PlanningFocus.highProtein => dish.proteinG / 40,
      PlanningFocus.variety => -usedCount * 0.6,
      PlanningFocus.quick => 0,
      PlanningFocus.balanced => 0,
    };
    final repeatPenalty = focus == PlanningFocus.variety ? 1.1 : 0.75;
    final preferredIndex = preferredDishIds.indexOf(dish.id);
    final aiBonus = preferredIndex < 0 || preferredDishIds.isEmpty
        ? 0
        : (preferredDishIds.length - preferredIndex) / preferredDishIds.length;
    return fit * 3 +
        value * 100 +
        budgetSafety +
        focusBonus +
        aiBonus -
        usedCount * repeatPenalty;
  }

  double _fitScore(NutritionTargets actual, NutritionTargets target) {
    double fit(double value, double desired) {
      if (desired <= 0) return 0;
      if (value <= desired) return value / desired;
      return 1 - ((value - desired) / desired).clamp(0, 1);
    }

    return (fit(actual.calories, target.calories) +
            fit(actual.proteinG, target.proteinG) +
            fit(actual.carbsG, target.carbsG) +
            fit(actual.fatG, target.fatG)) /
        4;
  }

  void _refine(
    List<MealSlotAssignment> assignments,
    List<PlannerDish> candidates,
    int budget,
    NutritionTargets target,
  ) {
    if (assignments.length < 2) return;
    var iteration = 0;
    while (iteration++ < maxRefinementIterations) {
      final before = _objective(assignments, target);
      var improved = false;
      for (var index = 0; index < assignments.length && !improved; index++) {
        final current = assignments[index].dish;
        for (final candidate in candidates) {
          if (candidate.id == current.id ||
              _createsAdjacentRepeat(assignments, index, candidate.id)) {
            continue;
          }
          final proposedCost =
              _totalCost(assignments) -
              current.roundedPriceCents +
              candidate.roundedPriceCents;
          if (proposedCost > budget) continue;
          final previous = assignments[index];
          assignments[index] = MealSlotAssignment(
            dayIndex: previous.dayIndex,
            slotIndex: previous.slotIndex,
            dish: candidate,
            reason: _reasonFor(candidate, budget - proposedCost, target),
          );
          final after = _objective(assignments, target);
          if (after > before + 0.0001) {
            improved = true;
            break;
          }
          assignments[index] = previous;
        }
      }
      if (!improved) break;
    }
  }

  bool _createsAdjacentRepeat(
    List<MealSlotAssignment> assignments,
    int index,
    int candidateId,
  ) {
    final previous = index == 0 ? null : assignments[index - 1].dish.id;
    final next = index + 1 >= assignments.length
        ? null
        : assignments[index + 1].dish.id;
    return candidateId == previous || candidateId == next;
  }

  double _objective(
    List<MealSlotAssignment> assignments,
    NutritionTargets target,
  ) {
    final totals = assignments.fold(
      const NutritionTargets(calories: 0, proteinG: 0, carbsG: 0, fatG: 0),
      (sum, item) {
        return NutritionTargets(
          calories: sum.calories + item.dish.calories,
          proteinG: sum.proteinG + item.dish.proteinG,
          carbsG: sum.carbsG + item.dish.carbsG,
          fatG: sum.fatG + item.dish.fatG,
        );
      },
    );
    final uniqueCount = assignments.map((item) => item.dish.id).toSet().length;
    final diversity = assignments.isEmpty
        ? 0
        : uniqueCount / assignments.length;
    return _fitScore(totals, target) + diversity * 0.45;
  }

  int _totalCost(List<MealSlotAssignment> assignments) =>
      assignments.fold(0, (sum, item) => sum + item.dish.roundedPriceCents);

  NutritionTargets _subtract(NutritionTargets left, NutritionTargets right) =>
      NutritionTargets(
        calories: (left.calories - right.calories).clamp(0, double.infinity),
        proteinG: (left.proteinG - right.proteinG).clamp(0, double.infinity),
        carbsG: (left.carbsG - right.carbsG).clamp(0, double.infinity),
        fatG: (left.fatG - right.fatG).clamp(0, double.infinity),
      );

  String _reasonFor(
    PlannerDish dish,
    int remainingBudget,
    NutritionTargets target,
  ) {
    final reasons = <String>[];
    if (dish.roundedPriceCents <= remainingBudget) reasons.add('fits budget');
    if (dish.proteinG >= target.proteinG * 0.2) reasons.add('supports protein');
    if (reasons.isEmpty) reasons.add('best available fit');
    return reasons.join(', ');
  }
}
