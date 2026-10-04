import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

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
      final preferredDishIds = await ref
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
      if (preferredDishIds.isEmpty) {
        throw StateError('Gemini returned an invalid meal plan.');
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
      await ref
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
  });

  final int day;
  final List<MealSlotAssignment> assignments;
  final AppCurrency currency;

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
            (assignment) => ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 15,
                child: Text('${assignment.slotIndex + 1}'),
              ),
              title: Text(assignment.dish.name),
              subtitle: Text(assignment.reason),
              trailing: Text(
                currency.formatCents(assignment.dish.roundedPriceCents),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
