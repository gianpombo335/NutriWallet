import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/allergy/dish_allergy_matcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/currency/app_currency.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';

import 'package:go_router/go_router.dart';

import 'domain/meal_planning_engine.dart';
import 'domain/planner_models.dart';
import '../nutrition_goal/domain/nutrition_models.dart';

class WeeklyPlanScreen extends ConsumerStatefulWidget {
  const WeeklyPlanScreen({super.key});

  @override
  ConsumerState<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends ConsumerState<WeeklyPlanScreen> {
  GeneratedMealPlan? _plan;
  int? _activePlanId;
  NutritionTargets? _target;
  PlanningFocus _focus = PlanningFocus.balanced;
  bool _busy = false;
  bool _restoring = true;
  bool _smartUsed = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_restoreActivePlan);
  }

  Future<void> _restoreActivePlan() async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) {
      if (mounted) setState(() => _restoring = false);
      return;
    }
    final active = await ref
        .read(mealPlanRepositoryProvider)
        .activePlan(profile.id);
    if (active != null) {
      final plan = await ref
          .read(mealPlanRepositoryProvider)
          .loadMealPlan(active);
      if (mounted) {
        setState(() {
          _plan = plan;
          _activePlanId = active.id;
          _target = _targetsFor(profile) * _activeDayCount(profile).toDouble();
          _focus = PlanningFocus.values.firstWhere(
            (focus) => focus.name == active.planningFocus,
            orElse: () => PlanningFocus.balanced,
          );
          _smartUsed = true;
        });
      }
    }
    if (mounted) setState(() => _restoring = false);
  }

  Future<void> _chooseFocus(UserProfile profile) async {
    final focus = await showModalBottomSheet<PlanningFocus>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(AppSpacing.page),
          children: [
            Text(
              'What kind of plan?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...PlanningFocus.values.map(
              (option) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: _focusColor(option).withValues(alpha: 0.14),
                  child: Icon(_focusIcon(option), color: _focusColor(option)),
                ),
                title: Text(option.label),
                subtitle: Text(option.description),
                trailing: option == _focus ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(context, option),
              ),
            ),
          ],
        ),
      ),
    );
    if (focus == null || !mounted) return;
    setState(() => _focus = focus);
    await _generate(profile);
  }

  Future<void> _openHistory() async {
    await context.push('/plans/history');
    if (mounted) await _restoreActivePlan();
  }

  Future<void> _generate(UserProfile profile) async {
    setState(() => _busy = true);
    try {
      final dishes = await ref
          .read(dishRepositoryProvider)
          .plannerDishes(profile.id);
      final exclusions =
          (await ref.read(profileDaoProvider).allergensForProfile(profile.id))
              .map((tag) => tag.label)
              .toSet();
      final days = _daysFor(profile);
      final targets = _targetsFor(profile) * days.length.toDouble();
      var preferredDishIds = const <int>[];
      try {
        preferredDishIds = await ref
            .read(smartPlanServiceProvider)
            .recommendDishIds(
              dishes: dishes,
              focus: _focus,
              budgetCents: profile.weeklyBudgetCents,
              targets: targets,
              days: days,
              mealsPerDay: profile.mealsPerDay,
              exclusions: exclusions,
              currencyCode: ref.read(currencyProvider).code,
            );
      } catch (_) {
        // AI recommendations are optional; the local planner remains usable.
      }
      final plan = const MealPlanningEngine().generateWeeklyPlan(
        dishes: dishes,
        budgetCents: profile.weeklyBudgetCents,
        nutritionTargets: targets,
        exclusions: exclusions,
        days: days,
        mealsPerDay: profile.mealsPerDay,
        focus: _focus,
        preferredDishIds: preferredDishIds,
      );
      _validateGeneratedPlan(plan, targets, days.length * profile.mealsPerDay);
      final savedPlan = await ref
          .read(mealPlanRepositoryProvider)
          .savePlan(
            profileId: profile.id,
            weekStartDate: _weekStart(DateTime.now()),
            plan: plan,
            planningFocus: _focus.name,
            currencyCode: ref.read(currencyProvider).code,
          );
      if (mounted) {
        setState(() {
          _plan = plan;
          _activePlanId = savedPlan.id;
          _target = targets;
          _smartUsed = preferredDishIds.isNotEmpty;
        });
      }
    } catch (error) {
      if (mounted) {
        final message = switch (error) {
          DioException(response: final response)
              when response?.statusCode == 422 =>
            'Gemini returned a plan that did not meet your budget or goals. Try again.',
          DioException() => 'Gemini is unavailable right now. Check your connection and try again.',
          StateError() => error.message.toString(),
          _ => 'Could not generate a plan. Try again.',
        };
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _replaceMeal(
    UserProfile profile,
    MealSlotAssignment assignment,
  ) async {
    final dishes = await ref
        .read(dishRepositoryProvider)
        .plannerDishes(profile.id);
    final exclusions =
        (await ref.read(profileDaoProvider).allergensForProfile(profile.id))
            .map((tag) => tag.label.trim().toLowerCase())
            .where((tag) => tag.isNotEmpty)
            .toSet();
    final choices = dishes
        .where(
          (dish) =>
              dish.id != assignment.dish.id && !_isExcluded(dish, exclusions),
        )
        .toList();
    if (!mounted) return;
    if (choices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No other eligible dishes are available.'),
        ),
      );
      return;
    }
    final selected = await showModalBottomSheet<PlannerDish>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: choices.length,
          separatorBuilder: (_, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final dish = choices[index];
            return ListTile(
              title: Text(dish.name),
              subtitle: Text(
                '${dish.calories.round()} kcal  •  '
                '${dish.proteinG.round()} g protein  •  '
                '${dish.carbsG.round()} g carbs  •  '
                '${dish.fatG.round()} g fat',
              ),
              trailing: Text(
                ref.read(currencyProvider).formatCents(dish.roundedPriceCents),
              ),
              onTap: () => Navigator.pop(context, dish),
            );
          },
        ),
      ),
    );
    if (selected != null) {
      await _applyMealEdit(
        profile,
        assignment,
        dish: selected,
        servings: assignment.servings,
      );
    }
  }

  Future<void> _changeServings(
    UserProfile profile,
    MealSlotAssignment assignment,
    double delta,
  ) async {
    final servings = (assignment.servings + delta).clamp(0.5, 20.0).toDouble();
    if (servings == assignment.servings) return;
    await _applyMealEdit(
      profile,
      assignment,
      dish: assignment.dish,
      servings: servings,
    );
  }

  Future<void> _applyMealEdit(
    UserProfile profile,
    MealSlotAssignment assignment, {
    required PlannerDish dish,
    required double servings,
  }) async {
    final currentPlan = _plan;
    final planId = _activePlanId;
    if (currentPlan == null || planId == null) return;
    final index = currentPlan.assignments.indexWhere(
      (item) =>
          item.dayIndex == assignment.dayIndex &&
          item.slotIndex == assignment.slotIndex,
    );
    if (index < 0) return;
    final updatedAssignment = assignment.copyWith(
      dish: dish,
      servings: servings,
      reason: 'manually adjusted',
    );
    final updatedAssignments = [...currentPlan.assignments];
    updatedAssignments[index] = updatedAssignment;
    final totalCostCents = updatedAssignments.fold<int>(
      0,
      (sum, item) => sum + item.plannedCostCents,
    );
    final updatedPlan = currentPlan.copyWith(
      assignments: updatedAssignments,
      totalCostCents: totalCostCents,
      isOverBudget: totalCostCents > profile.weeklyBudgetCents,
    );
    setState(() {
      _plan = updatedPlan;
      _busy = true;
    });
    try {
      await ref
          .read(mealPlanRepositoryProvider)
          .updateMealSlotPlan(
            profileId: profile.id,
            planId: planId,
            dayIndex: assignment.dayIndex,
            slotIndex: assignment.slotIndex,
            dish: dish,
            servings: servings,
          );
    } catch (_) {
      if (mounted) {
        setState(() => _plan = currentPlan);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save this plan change.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  bool _isExcluded(PlannerDish dish, Set<String> exclusions) {
    return dishMatchesAllergy(
      dishName: dish.name,
      ingredients: dish.ingredients,
      exclusions: exclusions,
    );
  }

  void _validateGeneratedPlan(
    GeneratedMealPlan plan,
    NutritionTargets targets,
    int expectedSlots,
  ) {
    if (plan.assignments.length != expectedSlots || plan.isOverBudget) {
      throw StateError(
        'The generated plan did not meet the budget or slot requirements.',
      );
    }
    final nutrition = PlanNutritionSummary.fromAssignments(plan.assignments);
    if (_focus == PlanningFocus.highProtein &&
        nutrition.proteinG < targets.proteinG * 0.7) {
      throw StateError('The generated plan did not meet the protein goal.');
    }
    if (_focus == PlanningFocus.variety &&
        plan.assignments.map((item) => item.dish.id).toSet().length <
            (expectedSlots > 1 ? 2 : 1)) {
      throw StateError('The generated plan did not meet the variety goal.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider).value;
    final currency = ref.watch(currencyProvider);
    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_restoring) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        4,
        AppSpacing.page,
        96,
      ),
      children: [
        Text(
          'A practical week from your library',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          _smartUsed
              ? 'AI suggested this rotation; the planner validated budget, nutrition, and variety.'
              : 'The online recommendation was unavailable, so the planner generated a validated plan.',
        ),
        const SizedBox(height: AppSpacing.section),
        OutlinedButton.icon(
          onPressed: _openHistory,
          icon: const Icon(Icons.history),
          label: const Text('View plan history'),
        ),
        const SizedBox(height: AppSpacing.item),
        if (_plan == null)
          _EmptyPlanCard(onGenerate: _busy ? null : () => _chooseFocus(profile))
        else ...[
          _PlanSummary(
            plan: _plan!,
            budgetCents: profile.weeklyBudgetCents,
            target: _target,
            currency: currency,
            focus: _focus,
          ),
          const SizedBox(height: AppSpacing.item),
          FilledButton.icon(
            onPressed: _busy ? null : () => _generate(profile),
            icon: const Icon(Icons.refresh),
            label: Text(_busy ? 'Regenerating...' : 'Regenerate plan'),
          ),
          TextButton.icon(
            onPressed: _busy ? null : () => _chooseFocus(profile),
            icon: const Icon(Icons.tune),
            label: Text('Focus: ${_focus.label}'),
          ),
          const SizedBox(height: AppSpacing.section),
          ..._groupByDay(_plan!.assignments).entries.map(
            (entry) => _DayCard(
              day: entry.key,
              assignments: entry.value,
              currency: currency,
              enabled: !_busy,
              onReplace: (assignment) => _replaceMeal(profile, assignment),
              onServingsChanged: (assignment, delta) =>
                  _changeServings(profile, assignment, delta),
            ),
          ),
        ],
      ],
    );
  }

  NutritionTargets _targetsFor(UserProfile profile) {
    if (profile.weightKg == null ||
        profile.heightCm == null ||
        profile.age == null ||
        profile.sex == null) {
      return const NutritionTargets(
        calories: 2000,
        proteinG: 150,
        carbsG: 200,
        fatG: 67,
      );
    }
    final sex = profile.sex == 'female' ? Sex.female : Sex.male;
    final activity = _activityFor(profile.activityLevel);
    final goal = _goalFor(profile.goalPreset);
    final tdee = NutritionCalculator.tdee(
      weightKg: profile.weightKg!,
      heightCm: profile.heightCm!,
      age: profile.age!,
      sex: sex,
      activityLevel: activity,
    );
    return NutritionCalculator.targetsFor(tdee: tdee, preset: goal);
  }

  ActivityLevel _activityFor(String value) => switch (value) {
    'very_active' || 'veryActive' => ActivityLevel.veryActive,
    'active' => ActivityLevel.active,
    'light' => ActivityLevel.light,
    'sedentary' => ActivityLevel.sedentary,
    _ => ActivityLevel.moderate,
  };

  GoalPreset _goalFor(String value) => switch (value) {
    'high_protein' || 'highProtein' => GoalPreset.highProtein,
    'cutting' => GoalPreset.cutting,
    'bulking' => GoalPreset.bulking,
    'keto' => GoalPreset.keto,
    _ => GoalPreset.balanced,
  };

  int _activeDayCount(UserProfile profile) => _daysFor(profile).length;

  List<int> _daysFor(UserProfile profile) {
    final days = profile.activeDays
        .split(',')
        .map(int.tryParse)
        .whereType<int>()
        .toList();
    return days.isEmpty ? [1, 2, 3, 4, 5, 6, 7] : days;
  }

  Map<int, List<MealSlotAssignment>> _groupByDay(
    List<MealSlotAssignment> assignments,
  ) {
    final grouped = <int, List<MealSlotAssignment>>{};
    for (final assignment in assignments) {
      grouped.putIfAbsent(assignment.dayIndex, () => []).add(assignment);
    }
    return grouped;
  }

  DateTime _weekStart(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day - (date.weekday - 1));
}

IconData _focusIcon(PlanningFocus focus) => switch (focus) {
  PlanningFocus.balanced => Icons.auto_awesome,
  PlanningFocus.budget => Icons.savings_outlined,
  PlanningFocus.highProtein => Icons.fitness_center,
  PlanningFocus.variety => Icons.diversity_3_outlined,
  PlanningFocus.quick => Icons.bolt_outlined,
};

Color _focusColor(PlanningFocus focus) => switch (focus) {
  PlanningFocus.balanced => const Color(0xFF6B4EFF),
  PlanningFocus.budget => const Color(0xFFB7791F),
  PlanningFocus.highProtein => const Color(0xFFD64545),
  PlanningFocus.variety => const Color(0xFF168AAD),
  PlanningFocus.quick => const Color(0xFF7B61A8),
};

class _EmptyPlanCard extends StatelessWidget {
  const _EmptyPlanCard({required this.onGenerate});

  final VoidCallback? onGenerate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome, size: 32),
            const SizedBox(height: 12),
            Text(
              'Ready when you are.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a few dishes, then let the planner balance cost and nutrition for the week.',
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Generate my plan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanSummary extends StatelessWidget {
  const _PlanSummary({
    required this.plan,
    required this.budgetCents,
    required this.target,
    required this.currency,
    required this.focus,
  });

  final GeneratedMealPlan plan;
  final int budgetCents;
  final NutritionTargets? target;
  final AppCurrency currency;
  final PlanningFocus focus;

  @override
  Widget build(BuildContext context) {
    final overBudget = plan.isOverBudget;
    final color = overBudget ? AppColors.errorRed : AppColors.successGreen;
    final nutrition = PlanNutritionSummary.fromAssignments(plan.assignments);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: Icon(
                  _focusIcon(focus),
                  size: 18,
                  color: _focusColor(focus),
                ),
                label: Text(focus.label),
                side: BorderSide(
                  color: _focusColor(focus).withValues(alpha: 0.35),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  overBudget
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  overBudget ? 'Over budget' : 'Within budget',
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              currency.formatCents(plan.totalCostCents),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text('of ${currency.formatCents(budgetCents)} weekly budget'),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: budgetCents == 0
                  ? 0
                  : (plan.totalCostCents / budgetCents).clamp(0, 1),
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              '${plan.assignments.length} meal slots planned',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            Text(
              'Nutrition in this plan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MacroChip(
                  label: 'Calories',
                  value: '${nutrition.calories.round()} kcal',
                  target: target?.calories,
                ),
                _MacroChip(
                  label: 'Protein',
                  value: '${nutrition.proteinG.round()} g',
                  target: target?.proteinG,
                ),
                _MacroChip(
                  label: 'Carbs',
                  value: '${nutrition.carbsG.round()} g',
                  target: target?.carbsG,
                ),
                _MacroChip(
                  label: 'Fat',
                  value: '${nutrition.fatG.round()} g',
                  target: target?.fatG,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.label, required this.value, this.target});

  final String label;
  final String value;
  final double? target;

  @override
  Widget build(BuildContext context) {
    final targetText = target == null ? '' : ' / ${target!.round()}';
    return Container(
      width: 145,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 3),
          Text(
            '$value$targetText',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (target != null)
            Text('target', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day,
    required this.assignments,
    required this.currency,
    required this.enabled,
    required this.onReplace,
    required this.onServingsChanged,
  });

  final int day;
  final List<MealSlotAssignment> assignments;
  final AppCurrency currency;
  final bool enabled;
  final Future<void> Function(MealSlotAssignment assignment) onReplace;
  final Future<void> Function(MealSlotAssignment assignment, double delta)
  onServingsChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Text(
              'Day $day',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...assignments.map(
            (assignment) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        child: Text('${assignment.slotIndex + 1}'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignment.dish.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(assignment.reason),
                            const SizedBox(height: 4),
                            Text(
                              '${assignment.nutrition.calories.round()} kcal  •  '
                              '${assignment.nutrition.proteinG.round()} g protein\n'
                              '${assignment.nutrition.carbsG.round()} g carbs  •  '
                              '${assignment.nutrition.fatG.round()} g fat',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        currency.formatCents(assignment.plannedCostCents),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 2,
                    children: [
                      const Text('Servings'),
                      IconButton(
                        tooltip: 'Decrease servings',
                        visualDensity: VisualDensity.compact,
                        onPressed: enabled
                            ? () => onServingsChanged(assignment, -0.5)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        _formatServings(assignment.servings),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        tooltip: 'Increase servings',
                        visualDensity: VisualDensity.compact,
                        onPressed: enabled
                            ? () => onServingsChanged(assignment, 0.5)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      TextButton.icon(
                        onPressed: enabled ? () => onReplace(assignment) : null,
                        icon: const Icon(Icons.swap_horiz),
                        label: const Text('Replace'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatServings(double servings) => servings == servings.roundToDouble()
    ? servings.toStringAsFixed(0)
    : servings.toStringAsFixed(1);
