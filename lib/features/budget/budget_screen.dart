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
            mealSlotId: entry.mealSlotId,
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
              if (value != null && value >= 0) {
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
    AppCurrency currency,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('I ate the planned meal'),
              onTap: () => Navigator.pop(sheetContext, 'eaten'),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('I ate something else'),
              onTap: () => Navigator.pop(sheetContext, 'substitute'),
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: const Text('Skip this meal'),
              onTap: () => Navigator.pop(sheetContext, 'skipped'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    var status = action;
    int? actualCost;
    String? substituteName;
    final plannedDate = DateTime.utc(
      plan.weekStartDate.year,
      plan.weekStartDate.month,
      plan.weekStartDate.day + slot.dayIndex - 1,
    );
    var consumedAt = plannedDate;
    if (action == 'eaten') {
      actualCost = slot.plannedCostCents;
    } else if (action == 'substitute') {
      final outcome = await showDialog<_MealOutcome>(
        context: context,
        builder: (_) =>
            _SubstituteMealDialog(currency: currency, initialDate: plannedDate),
      );
      if (outcome == null || !context.mounted) return;
      status = 'substitute';
      actualCost = (outcome.amount * 100).round();
      substituteName = outcome.name;
      consumedAt = outcome.consumedAt;
    }
    await ref
        .read(mealPlanRepositoryProvider)
        .updateMealSlot(
          profileId: profile.id,
          slotId: slot.id,
          mealStatus: status,
          consumedAt: consumedAt,
          actualCostCents: actualCost,
          substituteName: substituteName,
        );
    final checkInLabel = switch (status) {
      'eaten' =>
        'Meal eaten as planned · Day ${slot.dayIndex}, meal ${slot.slotIndex + 1}',
      'substitute' => 'Substitute meal: ${substituteName ?? 'Other meal'}',
      _ => 'Meal skipped · Day ${slot.dayIndex}, meal ${slot.slotIndex + 1}',
    };
    await ref
        .read(budgetRepositoryProvider)
        .upsertMealSlotExpense(
          profileId: profile.id,
          mealSlotId: slot.id,
          amountCents: actualCost ?? 0,
          label: checkInLabel,
          occurredAt: consumedAt,
          generatedPlanId: plan.id,
        );
    if (context.mounted) setState(() {});
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
        final entries = entriesSnapshot.data ?? const <BudgetEntry>[];
        return FutureBuilder<GeneratedPlan?>(
          future: ref.read(mealPlanRepositoryProvider).activePlan(profile.id),
          builder: (context, planSnapshot) {
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
                      final slots = slotsSnapshot.data ?? const <MealSlot>[];
                      if (slots.isEmpty) return const SizedBox.shrink();
                      return _MealCheckInCard(
                        plan: plan,
                        slots: slots,
                        currency: currency,
                        onCheckIn: (slot) => _checkInMeal(
                          context,
                          ref,
                          profile,
                          plan,
                          slot,
                          currency,
                        ),
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

  String _date(DateTime value) => '${value.month}/${value.day}/${value.year}';

  DateTime _weekStart(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day - (date.weekday - 1));
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

class _MealCheckInCard extends StatelessWidget {
  const _MealCheckInCard({
    required this.plan,
    required this.slots,
    required this.currency,
    required this.onCheckIn,
  });

  final GeneratedPlan plan;
  final List<MealSlot> slots;
  final AppCurrency currency;
  final Future<void> Function(MealSlot slot) onCheckIn;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: AppSpacing.item),
      child: ExpansionTile(
        title: const Text('Meal check-in'),
        subtitle: const Text('Mark what you actually ate and spent'),
        children: slots
            .map(
              (slot) => ListTile(
                leading: CircleAvatar(child: Text('${slot.dayIndex}')),
                title: Text(
                  slot.mealStatus == 'substitute' &&
                          slot.substituteName?.isNotEmpty == true
                      ? slot.substituteName!
                      : 'Planned meal · Meal ${slot.slotIndex + 1}',
                ),
                subtitle: Text(
                  '${_date(plan.weekStartDate.add(Duration(days: slot.dayIndex - 1)))} · ${_status(slot.mealStatus)}',
                ),
                trailing: slot.actualCostCents == null
                    ? const Icon(Icons.more_horiz)
                    : Text(currency.formatCents(slot.actualCostCents!)),
                onTap: () => onCheckIn(slot),
              ),
            )
            .toList(),
      ),
    );
  }

  String _status(String status) => switch (status) {
    'eaten' => 'Eaten as planned',
    'substitute' => 'Substitute recorded',
    'skipped' => 'Skipped',
    _ => 'Not checked in',
  };

  String _date(DateTime value) => '${value.month}/${value.day}/${value.year}';
}

class _MealOutcome {
  const _MealOutcome({
    required this.name,
    required this.amount,
    required this.consumedAt,
  });

  final String name;
  final double amount;
  final DateTime consumedAt;
}

class _SubstituteMealDialog extends StatefulWidget {
  const _SubstituteMealDialog({
    required this.currency,
    required this.initialDate,
  });

  final AppCurrency currency;
  final DateTime initialDate;

  @override
  State<_SubstituteMealDialog> createState() => _SubstituteMealDialogState();
}

class _SubstituteMealDialogState extends State<_SubstituteMealDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  late DateTime _consumedAt;

  @override
  void initState() {
    super.initState();
    _consumedAt = widget.initialDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _consumedAt,
    );
    if (picked != null) setState(() => _consumedAt = picked);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record a substitute meal'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'What did you eat?'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Amount spent',
                prefixText: '${widget.currency.symbol} ',
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  'Date: ${_consumedAt.month}/${_consumedAt.day}/${_consumedAt.year}',
                ),
              ),
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
            final name = _nameController.text.trim();
            final amount = double.tryParse(_amountController.text.trim());
            if (name.isEmpty || amount == null || amount <= 0) return;
            Navigator.pop(
              context,
              _MealOutcome(
                name: name,
                amount: amount,
                consumedAt: _consumedAt.toUtc(),
              ),
            );
          },
          child: const Text('Save meal'),
        ),
      ],
    );
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
            if (amount == null || amount <= 0) return;
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
