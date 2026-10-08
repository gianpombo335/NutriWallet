import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/currency/app_currency.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';
import '../../data/remote/sync_service.dart';
import '../meal_planner/meal_check_in.dart';
import '../meal_planner/domain/meal_schedule.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  bool _showLinkedOnly = false;

  Future<void> _addSpend(
    BuildContext context,
    WidgetRef ref,
    int profileId,
    int? activePlanId,
    AppCurrency currency,
  ) async {
    final draft = await showDialog<_SpendDraft>(
      context: context,
      builder: (_) => _AddSpendDialog(
        currency: currency,
        hasActivePlan: activePlanId != null,
      ),
    );
    if (draft == null || !context.mounted) return;
    try {
      await ref
          .read(budgetRepositoryProvider)
          .addEntry(
            profileId: profileId,
            amountCents: (draft.amount * 100).round(),
            label: draft.label,
            occurredAt: draft.occurredAt,
            generatedPlanId: draft.linkToActivePlan ? activePlanId : null,
            mealSlotId: null,
          );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not record this expense.')),
        );
      }
    }
  }

  Future<void> _editSpend(
    BuildContext context,
    WidgetRef ref,
    BudgetEntry entry,
    int? activePlanId,
    AppCurrency currency,
  ) async {
    final draft = await showDialog<_SpendDraft>(
      context: context,
      builder: (_) => _AddSpendDialog(
        currency: currency,
        initialEntry: entry,
        hasActivePlan: activePlanId != null,
      ),
    );
    if (draft == null || !context.mounted) return;
    try {
      await ref
          .read(budgetRepositoryProvider)
          .updateEntry(
            entry: entry,
            amountCents: (draft.amount * 100).round(),
            label: draft.label,
            occurredAt: draft.occurredAt,
            generatedPlanId: draft.linkToActivePlan ? activePlanId : null,
            mealSlotId: draft.linkToActivePlan ? entry.mealSlotId : null,
          );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update this expense.')),
        );
      }
    }
  }

  Future<void> _adjustBudget(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
    AppCurrency currency,
  ) async {
    final controller = TextEditingController(
      text: (profile.weeklyBudgetCents / 100).toStringAsFixed(2),
    );
    final amount = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Adjust weekly budget'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Weekly limit',
            prefixText: '${currency.symbol} ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text.trim());
              if (value != null &&
                  value.isFinite &&
                  value >= 0 &&
                  value <= 10000000) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('Update budget'),
          ),
        ],
      ),
    );
    if (amount == null || !context.mounted) return;
    try {
      final now = DateTime.now().toUtc();
      await ref
          .read(profileDaoProvider)
          .updateProfile(
            UserProfilesCompanion(
              id: Value(profile.id),
              weeklyBudgetCents: Value((amount * 100).round()),
              updatedAt: Value(now),
            ),
          );
      final saved = await ref.read(profileDaoProvider).findById(profile.id);
      if (saved != null) {
        await SyncQueueRepository(ref.read(databaseProvider)).enqueue(
          entityTable: 'UserProfiles',
          entityId: saved.id,
          operation: 'update',
          payload: userProfileSyncPayload(saved),
          dirtyAt: saved.updatedAt,
        );
      }
      ref.invalidate(currentProfileProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update your budget.')),
        );
      }
    }
  }

  Future<void> _deleteSpend(
    BuildContext context,
    WidgetRef ref,
    BudgetEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove expense?'),
        content: Text('Remove "${entry.label}" from this week?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(budgetRepositoryProvider).deleteEntry(entry);
  }

  Future<void> _checkInMeal(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
    GeneratedPlan plan,
    MealSlot slot,
    AppCurrency currency, {
    String? preferredStatus,
  }) async {
    await MealCheckInFlow.show(
      context: context,
      budgetRepository: ref.read(budgetRepositoryProvider),
      profile: profile,
      plan: plan,
      slot: slot,
      schedule: MealSchedule.fromJson(
        profile.mealTimesJson,
        profile.mealsPerDay,
      ),
      currency: currency,
      preferredStatus: preferredStatus,
    );
    if (context.mounted) setState(() {});
  }

  Future<void> _autoSkipMeals(
    UserProfile profile,
    GeneratedPlan plan,
    List<MealSlot> slots,
    AppCurrency currency,
  ) async {
    final schedule = MealSchedule.fromJson(
      profile.mealTimesJson,
      profile.mealsPerDay,
    );
    for (final slot in slots) {
      final updated = await MealCheckInFlow.show(
        context: context,
        budgetRepository: ref.read(budgetRepositoryProvider),
        profile: profile,
        plan: plan,
        slot: slot,
        schedule: schedule,
        currency: currency,
        preferredStatus: 'skipped',
      );
      if (!updated) throw StateError('Could not auto-skip a meal.');
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final profile = ref.watch(currentProfileProvider).value;
    final currency = ref.watch(currencyProvider);
    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final weekStart = _weekStart(DateTime.now());
    return StreamBuilder<List<BudgetEntry>>(
      stream: ref
          .watch(budgetRepositoryProvider)
          .watchEntries(
            profile.id,
            from: weekStart,
            until: weekStart.add(const Duration(days: 7)),
          ),
      builder: (context, entriesSnapshot) {
        if (entriesSnapshot.hasError) {
          return const Center(child: Text('Could not load budget entries.'));
        }
        final entries = entriesSnapshot.data ?? const <BudgetEntry>[];
        return FutureBuilder<GeneratedPlan?>(
          future: ref.read(mealPlanRepositoryProvider).activePlan(profile.id),
          builder: (context, planSnapshot) {
            if (planSnapshot.hasError) {
              return const Center(
                child: Text('Could not load the active plan.'),
              );
            }
            final plan = planSnapshot.data;
            final budget = profile.weeklyBudgetCents;
            final planned = plan?.totalProjectedCostCents ?? 0;
            final actual = entries.fold<int>(
              0,
              (sum, entry) => sum + entry.amountCents,
            );
            final comparisonMax =
                [budget, planned, actual, 1].reduce((a, b) => a > b ? a : b) /
                100;
            final plannedRatio = (planned / 100) / comparisonMax;
            final actualRatio = (actual / 100) / comparisonMax;
            final overBudget = planned > budget || actual > budget;
            final linkedActual = entries
                .where((entry) => entry.generatedPlanId == plan?.id)
                .fold<int>(0, (sum, entry) => sum + entry.amountCents);
            final visibleEntries = _showLinkedOnly && plan != null
                ? entries
                      .where((entry) => entry.generatedPlanId == plan.id)
                      .toList()
                : entries;
            final statusColor = overBudget
                ? AppColors.errorRed
                : AppColors.successGreen;
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                4,
                AppSpacing.page,
                32,
              ),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'This week',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _adjustBudget(
                                context,
                                ref,
                                profile,
                                currency,
                              ),
                              icon: const Icon(Icons.tune, size: 18),
                              label: const Text('Adjust'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currency.formatCents(actual),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                'actual of ${currency.formatCents(budget)}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        LinearProgressIndicator(
                          value: budget == 0
                              ? 0
                              : (actual / budget).clamp(0, 1).toDouble(),
                          color: statusColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          overBudget
                              ? 'Your plan or actual spending is over the weekly limit.'
                              : 'Your actual spend is within the weekly limit.',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.item),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 18, 18, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            'Planned vs actual',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 180,
                          child: BarChart(
                            BarChartData(
                              maxY: 1,
                              minY: 0,
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: plannedRatio,
                                      color: AppColors.budgetGold,
                                      width: 34,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: actualRatio,
                                      color: AppColors.primaryGreen,
                                      width: 34,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _Legend(
                              color: AppColors.budgetGold,
                              label: 'Planned ${currency.formatCents(planned)}',
                            ),
                            const SizedBox(width: 18),
                            _Legend(
                              color: AppColors.primaryGreen,
                              label: 'Actual ${currency.formatCents(actual)}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.item),
                if (plan != null)
                  Card(
                    color: const Color(0xFFF3F7F1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active meal plan',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Planned ${currency.formatCents(planned)} · linked actual ${currency.formatCents(linkedActual)}',
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: planned == 0
                                ? 0
                                : (linkedActual / planned)
                                      .clamp(0, 1)
                                      .toDouble(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            linkedActual > planned
                                ? 'Linked spending is above the plan projection.'
                                : 'Link grocery trips to this plan to compare real cost with the projection.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (plan != null) const SizedBox(height: AppSpacing.item),
                Text(
                  plan == null
                      ? 'No active plan is selected. Actual spending is tracked independently.'
                      : 'Active plan: planned ${currency.formatCents(planned)}. Actual spending can differ.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () =>
                      _addSpend(context, ref, profile.id, plan?.id, currency),
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Record grocery spend'),
                ),
                if (plan != null) ...[
                  const SizedBox(height: AppSpacing.item),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All entries'),
                        selected: !_showLinkedOnly,
                        onSelected: (_) =>
                            setState(() => _showLinkedOnly = false),
                      ),
                      ChoiceChip(
                        label: const Text('Linked to plan'),
                        selected: _showLinkedOnly,
                        onSelected: (_) =>
                            setState(() => _showLinkedOnly = true),
                      ),
                    ],
                  ),
                  FutureBuilder<List<MealSlot>>(
                    future: ref
                        .read(mealPlanRepositoryProvider)
                        .slotsForPlan(plan.id),
                    builder: (context, slotsSnapshot) {
                      if (slotsSnapshot.hasError) {
                        return const Card(
                          child: ListTile(
                            leading: Icon(Icons.error_outline),
                            title: Text('Meal timeline unavailable'),
                            subtitle: Text('Try again shortly.'),
                          ),
                        );
                      }
                      if (slotsSnapshot.connectionState ==
                              ConnectionState.waiting &&
                          !slotsSnapshot.hasData) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(18),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Loading meal timeline...'),
                              ],
                            ),
                          ),
                        );
                      }
                      final slots = slotsSnapshot.data ?? const <MealSlot>[];
                      if (slots.isEmpty) return const SizedBox.shrink();
                      return _MealCheckInCard(
                        plan: plan,
                        slots: slots,
                        schedule: MealSchedule.fromJson(
                          profile.mealTimesJson,
                          profile.mealsPerDay,
                        ),
                        currency: currency,
                        onCheckIn: (slot, {preferredStatus}) => _checkInMeal(
                          context,
                          ref,
                          profile,
                          plan,
                          slot,
                          currency,
                          preferredStatus: preferredStatus,
                        ),
                        onAutoSkip: (slots) =>
                            _autoSkipMeals(profile, plan, slots, currency),
                      );
                    },
                  ),
                ],
                if (visibleEntries.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.section),
                  Text(
                    'Recent entries',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...visibleEntries
                      .take(5)
                      .map(
                        (entry) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.shopping_bag_outlined),
                          title: Text(entry.label),
                          subtitle: Text(_date(entry.occurredAt)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(currency.formatCents(entry.amountCents)),
                              IconButton(
                                onPressed: () => _editSpend(
                                  context,
                                  ref,
                                  entry,
                                  plan?.id,
                                  currency,
                                ),
                                icon: const Icon(Icons.edit_outlined),
                                tooltip: 'Edit expense',
                              ),
                              IconButton(
                                onPressed: () =>
                                    _deleteSpend(context, ref, entry),
                                icon: const Icon(Icons.delete_outline),
                                tooltip: 'Remove expense',
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  String _date(DateTime value) {
    final local = value.toLocal();
    return '${local.month}/${local.day}/${local.year}';
  }

  DateTime _weekStart(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 1)).toUtc();
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 5),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _MealCheckInCard extends StatefulWidget {
  const _MealCheckInCard({
    required this.plan,
    required this.slots,
    required this.schedule,
    required this.currency,
    required this.onCheckIn,
    required this.onAutoSkip,
  });

  final GeneratedPlan plan;
  final List<MealSlot> slots;
  final MealSchedule schedule;
  final AppCurrency currency;
  final Future<void> Function(MealSlot slot, {String? preferredStatus})
  onCheckIn;
  final Future<void> Function(List<MealSlot> slots) onAutoSkip;

  @override
  State<_MealCheckInCard> createState() => _MealCheckInCardState();
}

class _MealCheckInCardState extends State<_MealCheckInCard> {
  Timer? _timer;
  bool _autoSkipInFlight = false;
  final _autoSkipRequested = <int>{};

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
        _maybeAutoSkip();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoSkip());
  }

  @override
  void didUpdateWidget(covariant _MealCheckInCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.plan.id != widget.plan.id) _autoSkipRequested.clear();
    _maybeAutoSkip();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduled = MealScheduleResolver.resolve(
      plan: widget.plan,
      slots: widget.slots,
      schedule: widget.schedule,
    );
    final current = MealScheduleResolver.currentMeal(scheduled);
    final next = MealScheduleResolver.nextMeal(scheduled);
    return Card(
      margin: const EdgeInsets.only(top: AppSpacing.item),
      child: ExpansionTile(
        title: const Text('Meal timeline'),
        subtitle: Text(
          next != null
              ? 'Next: Meal ${next.slot.slotIndex + 1} · ${_time(next.scheduledAt)}'
              : current == null
              ? 'All scheduled meals are checked in'
              : 'Current: Meal ${current.slot.slotIndex + 1} · ${_time(current.scheduledAt)}',
        ),
        children: [
          if (next != null)
            _highlight(
              context,
              label: 'NEXT MEAL',
              meal: next,
              color: AppColors.budgetGold,
            ),
          if (current != null)
            _highlight(
              context,
              label: 'CURRENT MEAL',
              meal: current,
              color: Theme.of(context).colorScheme.primary,
            ),
          ...scheduled.map(
            (meal) => ListTile(
              leading: CircleAvatar(child: Text('${meal.slot.dayIndex}')),
              title: Text(
                meal.slot.mealStatus == 'substitute' &&
                        meal.slot.substituteName?.isNotEmpty == true
                    ? meal.slot.substituteName!
                    : 'Meal ${meal.slot.slotIndex + 1}',
              ),
              subtitle: Text(
                '${_date(meal.scheduledAt)} · ${_time(meal.scheduledAt)} · ${_status(meal.slot.mealStatus)}',
              ),
              trailing: meal.slot.actualCostCents == null
                  ? const Icon(Icons.edit_outlined)
                  : Text(
                      widget.currency.formatCents(meal.slot.actualCostCents!),
                    ),
              onTap: () => widget.onCheckIn(meal.slot),
            ),
          ),
        ],
      ),
    );
  }

  Widget _highlight(
    BuildContext context, {
    required String label,
    required ScheduledMeal meal,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$label · Meal ${meal.slot.slotIndex + 1}\n${_date(meal.scheduledAt)} at ${_time(meal.scheduledAt)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              FilledButton.tonalIcon(
                onPressed: _autoSkipInFlight
                    ? null
                    : () =>
                          widget.onCheckIn(meal.slot, preferredStatus: 'eaten'),
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Eaten'),
              ),
              OutlinedButton.icon(
                onPressed: _autoSkipInFlight
                    ? null
                    : () => widget.onCheckIn(
                        meal.slot,
                        preferredStatus: 'substitute',
                      ),
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: const Text('Substitute'),
              ),
              TextButton.icon(
                onPressed: _autoSkipInFlight
                    ? null
                    : () => widget.onCheckIn(
                        meal.slot,
                        preferredStatus: 'skipped',
                      ),
                icon: const Icon(Icons.remove_circle_outline, size: 18),
                label: const Text('Skip'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _maybeAutoSkip() {
    if (_autoSkipInFlight || !mounted) return;
    final scheduled = MealScheduleResolver.resolve(
      plan: widget.plan,
      slots: widget.slots,
      schedule: widget.schedule,
    );
    final candidates = MealScheduleResolver.mealsToAutoSkip(scheduled)
        .where((meal) => !_autoSkipRequested.contains(meal.slot.id))
        .map((meal) => meal.slot)
        .toList();
    if (candidates.isEmpty) return;
    _autoSkipRequested.addAll(candidates.map((slot) => slot.id));
    _autoSkipInFlight = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await widget.onAutoSkip(candidates);
      } catch (_) {
        _autoSkipRequested.removeAll(candidates.map((slot) => slot.id));
      } finally {
        _autoSkipInFlight = false;
        if (mounted) setState(() {});
      }
    });
  }

  String _status(String status) => switch (status) {
    'eaten' => 'Eaten as planned',
    'substitute' => 'Substitute recorded',
    'skipped' => 'Skipped',
    _ => 'Not checked in',
  };

  String _date(DateTime value) => '${value.month}/${value.day}/${value.year}';

  String _time(DateTime value) {
    final suffix = value.hour >= 12 ? 'PM' : 'AM';
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    return '$hour:${value.minute.toString().padLeft(2, '0')} $suffix';
  }
}

class _SpendDraft {
  const _SpendDraft({
    required this.amount,
    required this.label,
    required this.linkToActivePlan,
    required this.occurredAt,
  });

  final double amount;
  final String label;
  final bool linkToActivePlan;
  final DateTime occurredAt;
}

class _AddSpendDialog extends StatefulWidget {
  const _AddSpendDialog({
    required this.currency,
    this.initialEntry,
    required this.hasActivePlan,
  });

  final AppCurrency currency;
  final BudgetEntry? initialEntry;
  final bool hasActivePlan;

  @override
  State<_AddSpendDialog> createState() => _AddSpendDialogState();
}

class _AddSpendDialogState extends State<_AddSpendDialog> {
  late final TextEditingController _amount;
  late final TextEditingController _label;
  bool _linkToActivePlan = false;
  late DateTime _occurredAt;

  @override
  void initState() {
    super.initState();
    final entry = widget.initialEntry;
    _amount = TextEditingController(
      text: entry == null ? '' : (entry.amountCents / 100).toStringAsFixed(2),
    );
    _label = TextEditingController(text: entry?.label ?? 'Grocery trip');
    _linkToActivePlan = entry?.generatedPlanId != null;
    _occurredAt = entry?.occurredAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _amount.dispose();
    _label.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _occurredAt,
    );
    if (picked != null) setState(() => _occurredAt = picked);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialEntry == null
            ? 'Record grocery spend'
            : 'Edit grocery spend',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '${widget.currency.symbol} ',
              ),
            ),
            const SizedBox(height: 12),
            if (widget.hasActivePlan)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Link to active plan'),
                subtitle: const Text(
                  'Optional; actual spending is always tracked.',
                ),
                value: _linkToActivePlan,
                onChanged: (value) =>
                    setState(() => _linkToActivePlan = value ?? false),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                children: [5, 10, 25, 50]
                    .map(
                      (amount) => ActionChip(
                        label: Text('${widget.currency.symbol}$amount'),
                        onPressed: () => setState(
                          () => _amount.text = amount.toStringAsFixed(2),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  'Date: ${_occurredAt.month}/${_occurredAt.day}/${_occurredAt.year}',
                ),
              ),
            ),
            TextField(
              controller: _label,
              decoration: const InputDecoration(labelText: 'Label'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final amount = double.tryParse(_amount.text);
            if (amount == null ||
                !amount.isFinite ||
                amount <= 0 ||
                amount > 10000000) {
              return;
            }
            Navigator.pop(
              context,
              _SpendDraft(
                amount: amount,
                label: _label.text,
                linkToActivePlan: _linkToActivePlan,
                occurredAt: _occurredAt.toUtc(),
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
