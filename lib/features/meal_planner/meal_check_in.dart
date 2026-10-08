import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/currency/app_currency.dart';
import '../../data/local/database.dart';
import '../../data/repositories/budget_repository.dart';
import 'domain/meal_schedule.dart';

class MealCheckInFlow {
  const MealCheckInFlow._();

  static Future<bool> show({
    required BuildContext context,
    required BudgetRepository budgetRepository,
    required UserProfile profile,
    required GeneratedPlan plan,
    required MealSlot slot,
    required MealSchedule schedule,
    required AppCurrency currency,
    String? preferredStatus,
  }) async {
    var status = preferredStatus;
    status ??= await showModalBottomSheet<String>(
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
    if (status == null || !context.mounted) return false;

    final scheduledAt = MealScheduleResolver.resolve(
      plan: plan,
      slots: [slot],
      schedule: schedule,
    ).single.scheduledAt;
    var consumedAt = scheduledAt;
    int? actualCost;
    String? substituteName;

    if (status == 'eaten') {
      actualCost = slot.plannedCostCents;
    } else if (status == 'substitute') {
      final outcome = await showDialog<MealOutcome>(
        context: context,
        builder: (_) => SubstituteMealDialog(
          currency: currency,
          initialDate: scheduledAt,
          initialName: slot.substituteName,
          initialAmount: slot.actualCostCents,
        ),
      );
      if (outcome == null || !context.mounted) return false;
      actualCost = (outcome.amount * 100).round();
      substituteName = outcome.name;
      consumedAt = outcome.consumedAt;
    } else if (status != 'skipped') {
      return false;
    }

    final label = switch (status) {
      'eaten' =>
        'Meal eaten as planned · Day ${slot.dayIndex}, meal ${slot.slotIndex + 1}',
      'substitute' => 'Substitute meal: ${substituteName ?? 'Other meal'}',
      _ => 'Meal skipped · Day ${slot.dayIndex}, meal ${slot.slotIndex + 1}',
    };

    try {
      await budgetRepository.recordMealCheckIn(
        profileId: profile.id,
        planId: plan.id,
        slotId: slot.id,
        mealStatus: status,
        consumedAt: consumedAt,
        actualCostCents: actualCost,
        substituteName: substituteName,
        label: label,
      );
      return true;
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update this meal.')),
        );
      }
      return false;
    }
  }
}

class MealStatusDashboard extends StatefulWidget {
  const MealStatusDashboard({
    super.key,
    required this.plan,
    required this.slots,
    required this.schedule,
    required this.currency,
    required this.mealTitle,
    required this.onQuickAction,
    required this.onMoreActions,
    required this.onAutoSkip,
  });

  final GeneratedPlan plan;
  final List<MealSlot> slots;
  final MealSchedule schedule;
  final AppCurrency currency;
  final String Function(MealSlot slot) mealTitle;
  final Future<void> Function(MealSlot slot, String status) onQuickAction;
  final Future<void> Function(MealSlot slot) onMoreActions;
  final Future<void> Function(List<MealSlot> slots) onAutoSkip;

  @override
  State<MealStatusDashboard> createState() => _MealStatusDashboardState();
}

class _MealStatusDashboardState extends State<MealStatusDashboard> {
  Timer? _timer;
  bool _actionInFlight = false;
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
  void didUpdateWidget(covariant MealStatusDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.plan.id != widget.plan.id) {
      _autoSkipRequested.clear();
    }
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
    final meal = next ?? current;
    final isCurrent = next == null && current != null;
    final color = Theme.of(context).colorScheme.primary;

    return Card(
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: meal == null
            ? Row(
                children: [
                  Icon(Icons.check_circle_outline, color: color),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'All scheduled meals are checked in.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restaurant_outlined, color: color),
                      const SizedBox(width: 8),
                      Text(
                        isCurrent ? 'Current meal' : 'Up next',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        widget.currency.formatCents(meal.slot.plannedCostCents),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.mealTitle(meal.slot),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_date(meal.scheduledAt)} · ${_time(meal.scheduledAt)} · '
                    'planned cost ${widget.currency.formatCents(meal.slot.plannedCostCents)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: _actionInFlight || _autoSkipInFlight
                            ? null
                            : () => _runAction(meal.slot, 'eaten'),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Eaten'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _actionInFlight || _autoSkipInFlight
                            ? null
                            : () => _runAction(meal.slot, 'substitute'),
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text('Substitute'),
                      ),
                      TextButton.icon(
                        onPressed: _actionInFlight || _autoSkipInFlight
                            ? null
                            : () => _runAction(meal.slot, 'skipped'),
                        icon: const Icon(Icons.remove_circle_outline, size: 18),
                        label: const Text('Skip'),
                      ),
                      TextButton(
                        onPressed: _actionInFlight || _autoSkipInFlight
                            ? null
                            : () => _runMoreActions(meal.slot),
                        child: const Text('More options'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _runAction(MealSlot slot, String status) async {
    if (_actionInFlight || _autoSkipInFlight) return;
    setState(() => _actionInFlight = true);
    try {
      await widget.onQuickAction(slot, status);
    } finally {
      if (mounted) setState(() => _actionInFlight = false);
    }
  }

  Future<void> _runMoreActions(MealSlot slot) async {
    if (_actionInFlight || _autoSkipInFlight) return;
    setState(() => _actionInFlight = true);
    try {
      await widget.onMoreActions(slot);
    } finally {
      if (mounted) setState(() => _actionInFlight = false);
    }
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

  String _date(DateTime value) => '${value.month}/${value.day}/${value.year}';

  String _time(DateTime value) {
    final suffix = value.hour >= 12 ? 'PM' : 'AM';
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    return '$hour:${value.minute.toString().padLeft(2, '0')} $suffix';
  }
}

class MealOutcome {
  const MealOutcome({
    required this.name,
    required this.amount,
    required this.consumedAt,
  });

  final String name;
  final double amount;
  final DateTime consumedAt;
}

class SubstituteMealDialog extends StatefulWidget {
  const SubstituteMealDialog({
    super.key,
    required this.currency,
    required this.initialDate,
    this.initialName,
    this.initialAmount,
  });

  final AppCurrency currency;
  final DateTime initialDate;
  final String? initialName;
  final int? initialAmount;

  @override
  State<SubstituteMealDialog> createState() => _SubstituteMealDialogState();
}

class _SubstituteMealDialogState extends State<SubstituteMealDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  late DateTime _consumedAt;

  @override
  void initState() {
    super.initState();
    _consumedAt = widget.initialDate;
    _nameController.text = widget.initialName ?? '';
    if (widget.initialAmount != null) {
      _amountController.text = (widget.initialAmount! / 100).toStringAsFixed(2);
    }
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
            if (name.isEmpty ||
                amount == null ||
                !amount.isFinite ||
                amount <= 0 ||
                amount > 10000000) {
              return;
            }
            Navigator.pop(
              context,
              MealOutcome(
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
