import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';
import 'domain/planner_models.dart';

class PlanHistoryScreen extends ConsumerWidget {
  const PlanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider).value;
    final currency = ref.watch(currencyProvider);
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Plan history')),
      body: FutureBuilder<List<GeneratedPlan>>(
        future: ref.read(mealPlanRepositoryProvider).history(profile.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Could not load plan history.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final plans = snapshot.data ?? const <GeneratedPlan>[];
          if (plans.isEmpty) {
            return const Center(
              child: Text('Generated plans will appear here.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.page),
            itemCount: plans.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final plan = plans[index];
              final focus = PlanningFocus.values.firstWhere(
                (item) => item.name == plan.planningFocus,
                orElse: () => PlanningFocus.balanced,
              );
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _focusColor(focus).withValues(alpha: 0.14),
                    child: Icon(_focusIcon(focus), color: _focusColor(focus)),
                  ),
                  title: Text('Version ${plan.version}'),
                  subtitle: Text(
                    '${focus.label} • Week of ${_date(plan.weekStartDate)} • Generated ${_date(plan.generatedAt)}',
                  ),
                  trailing: Text(
                    currency.formatCents(plan.totalProjectedCostCents),
                  ),
                  onTap: () async {
                    final activated = await context.push<bool>(
                      '/plans/history/${plan.id}',
                    );
                    if (activated == true && context.mounted) {
                      context.pop(true);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _date(DateTime value) => '${value.month}/${value.day}/${value.year}';
}

class PlanHistoryDetailScreen extends ConsumerWidget {
  const PlanHistoryDetailScreen({required this.planId, super.key});

  final int planId;

  Future<void> _setActive(BuildContext context, WidgetRef ref) async {
    final profile = ref.read(currentProfileProvider).value;
    if (profile == null) return;
    await ref
        .read(mealPlanRepositoryProvider)
        .setActivePlan(profileId: profile.id, planId: planId);
    if (context.mounted) {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan details')),
      body: FutureBuilder<_PlanDetail?>(
        future: _load(ref),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Could not load plan details.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final detail = snapshot.data;
          if (detail == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final currency = ref.watch(currencyProvider);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.page),
            children: [
              Card(
                child: ListTile(
                  title: Text('Version ${detail.plan.version}'),
                  subtitle: Text('Week of ${_date(detail.plan.weekStartDate)}'),
                  trailing: Text(
                    currency.formatCents(detail.plan.totalProjectedCostCents),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _setActive(context, ref),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Set as active plan'),
              ),
              const SizedBox(height: AppSpacing.section),
              Text('Meal slots', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...detail.slots.map((slot) {
                final assignment = detail.assignments.firstWhere(
                  (item) =>
                      item.dayIndex == slot.dayIndex &&
                      item.slotIndex == slot.slotIndex,
                  orElse: () => MealSlotAssignment(
                    dayIndex: slot.dayIndex,
                    slotIndex: slot.slotIndex,
                    dish: const PlannerDish(
                      id: 0,
                      name: 'Meal',
                      price: 0,
                      calories: 0,
                      proteinG: 0,
                      carbsG: 0,
                      fatG: 0,
                    ),
                    reason: 'saved plan',
                  ),
                );
                return ListTile(
                  leading: CircleAvatar(child: Text('${slot.dayIndex}')),
                  title: Text(
                    assignment.mealComponents
                        .map((component) => component.dish.name)
                        .join(' + '),
                  ),
                  subtitle: Text('${slot.plannedCalories.round()} kcal'),
                  trailing: Text(currency.formatCents(slot.plannedCostCents)),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Future<_PlanDetail?> _load(WidgetRef ref) async {
    final repository = ref.read(mealPlanRepositoryProvider);
    final profile = ref.read(currentProfileProvider).value;
    if (profile == null) return null;
    final plan = await repository.findByIdForProfile(planId, profile.id);
    if (plan == null) return null;
    return _PlanDetail(
      plan: plan,
      slots: await repository.slotsForPlan(planId),
      assignments: (await repository.loadMealPlan(plan)).assignments,
    );
  }

  String _date(DateTime value) => '${value.month}/${value.day}/${value.year}';
}

class _PlanDetail {
  const _PlanDetail({
    required this.plan,
    required this.slots,
    required this.assignments,
  });

  final GeneratedPlan plan;
  final List<MealSlot> slots;
  final List<MealSlotAssignment> assignments;
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
