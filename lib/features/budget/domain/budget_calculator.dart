import '../../meal_planner/domain/planner_models.dart';

class BudgetSummary {
  const BudgetSummary({
    required this.totalCostCents,
    required this.budgetCents,
  });

  final int totalCostCents;
  final int budgetCents;

  bool get isOverBudget => totalCostCents > budgetCents;
  int get remainingCents => budgetCents - totalCostCents;
}

class BudgetCalculator {
  const BudgetCalculator._();

  static BudgetSummary summarize(
    Iterable<PlannerDish> dishes,
    int budgetCents,
  ) {
    final total = dishes.fold<int>(
      0,
      (sum, dish) => sum + dish.roundedPriceCents,
    );
    return BudgetSummary(totalCostCents: total, budgetCents: budgetCents);
  }
}
