import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/currency/app_currency.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';
import '../../data/remote/sync_service.dart';
import '../nutrition_goal/domain/nutrition_models.dart';
import '../notifications/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider).value;
    final currency = ref.watch(currencyProvider);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.page),
      children: [
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text(profile?.email ?? 'Local account'),
            subtitle: const Text('Supabase connected mode'),
          ),
        ),
        if (profile?.weightKg != null &&
            profile?.heightCm != null &&
            profile?.age != null) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fitness profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'BMI ${NutritionCalculator.bmi(weightKg: profile!.weightKg!, heightCm: profile.heightCm!).toStringAsFixed(1)}',
                  ),
                  Text(
                    'BMR ${NutritionCalculator.bmr(weightKg: profile.weightKg!, heightCm: profile.heightCm!, age: profile.age!, sex: profile.sex == 'female' ? Sex.female : Sex.male).round()} kcal/day',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'BMI is a population-level screening measure and does not describe individual health on its own.',
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit profile'),
                subtitle: const Text('Budget, schedule, metrics, and goals'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/profile/edit'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: const Text('Weekly budget'),
                trailing: Text(
                  currency.formatCents(profile?.weeklyBudgetCents ?? 0),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: const Text('Currency'),
                subtitle: const Text(
                  'Display only; no exchange-rate conversion',
                ),
                trailing: DropdownButton<String>(
                  value: currency.code,
                  underline: const SizedBox.shrink(),
                  items: supportedCurrencies
                      .map(
                        (option) => DropdownMenuItem(
                          value: option.code,
                          child: Text('${option.symbol} ${option.code}'),
                        ),
                      )
                      .toList(),
                  onChanged: (code) async {
                    if (code == null) return;
                    await ref.read(currencyPreferencesProvider).setCode(code);
                    ref.read(currencyCodeProvider.notifier).state = code;
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Nutrition goal'),
                trailing: Text(profile?.goalPreset ?? 'Balanced'),
              ),
              const Divider(height: 1),
              const _ReminderSettings(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (profile != null) _AllergyEditor(profileId: profile.id),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () async {
            try {
              final count = await ref.read(syncServiceProvider).syncPending();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      count == 0
                          ? 'Nothing new to sync.'
                          : '$count pending changes synced.',
                    ),
                  ),
                );
              }
            } catch (_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Sync is unavailable. Changes remain safely queued.',
                    ),
                  ),
                );
              }
            }
          },
          icon: const Icon(Icons.sync),
          label: const Text('Sync pending changes'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            try {
              await ref.read(authRepositoryProvider).signOut();
              await ref
                  .read(mealReminderSchedulerProvider)
                  .cancel(_ReminderSettingsState._reminderId);
              await ref
                  .read(backgroundPlanSchedulerProvider)
                  .cancelWeeklyRegeneration();
              await ref.read(databaseProvider).clearAccountData();
              ref.invalidate(currentProfileProvider);
              if (context.mounted) context.go('/auth');
            } catch (_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not sign out safely. Try again.'),
                  ),
                );
              }
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
      ],
    );
  }
}

class _ReminderSettings extends ConsumerStatefulWidget {
  const _ReminderSettings();

  @override
  ConsumerState<_ReminderSettings> createState() => _ReminderSettingsState();
}

class _ReminderSettingsState extends ConsumerState<_ReminderSettings> {
  static const _reminderId = 1001;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = ref.read(notificationPreferencesProvider).enabled;
  }

  Future<void> _setEnabled(bool enabled) async {
    try {
      await ref.read(notificationPreferencesProvider).setEnabled(enabled);
      if (!enabled) {
        await ref.read(mealReminderSchedulerProvider).cancel(_reminderId);
        await ref
            .read(backgroundPlanSchedulerProvider)
            .cancelWeeklyRegeneration();
      }
      if (mounted) setState(() => _enabled = enabled);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update reminder settings.')),
        );
      }
    }
  }

  Future<void> _schedule() async {
    try {
      await ref
          .read(mealReminderSchedulerProvider)
          .schedule(
            MealReminder(
              id: _reminderId,
              title: 'Your next planned meal is ready.',
              scheduledAt: DateTime.now().add(const Duration(minutes: 1)),
            ),
          );
      await ref.read(backgroundPlanSchedulerProvider).initialize();
      await ref
          .read(backgroundPlanSchedulerProvider)
          .scheduleWeeklyRegeneration();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meal reminder and weekly regeneration scheduled.'),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not schedule reminders.')),
        );
      }
    }
  }

  Future<void> _cancel() async {
    try {
      await ref.read(mealReminderSchedulerProvider).cancel(_reminderId);
      await ref
          .read(backgroundPlanSchedulerProvider)
          .cancelWeeklyRegeneration();
      await ref.read(notificationPreferencesProvider).setEnabled(false);
      if (mounted) setState(() => _enabled = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meal reminders cancelled.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not cancel reminders.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.notifications_none),
          title: const Text('Meal reminders'),
          subtitle: const Text('Allow meal reminders and weekly regeneration'),
          value: _enabled,
          onChanged: _setEnabled,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _enabled ? _schedule : null,
                  child: const Text('Schedule reminders'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: _cancel,
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AllergyEditor extends ConsumerStatefulWidget {
  const _AllergyEditor({required this.profileId});

  final int profileId;

  @override
  ConsumerState<_AllergyEditor> createState() => _AllergyEditorState();
}

class _AllergyEditorState extends ConsumerState<_AllergyEditor> {
  final _controller = TextEditingController();
  late Future<List<AllergenTag>> _allergens;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _load() {
    _allergens = ref
        .read(profileDaoProvider)
        .allergensForProfile(widget.profileId);
  }

  Future<void> _add() async {
    final label = _controller.text.trim().toLowerCase();
    if (label.isEmpty) return;
    await ref.read(profileDaoProvider).addAllergen(widget.profileId, label);
    final matchingTags =
        (await ref
                .read(profileDaoProvider)
                .allergensForProfile(widget.profileId))
            .where((item) => item.label == label)
            .toList();
    final tag = matchingTags.isEmpty ? null : matchingTags.first;
    if (tag != null) {
      await SyncQueueRepository(ref.read(databaseProvider)).enqueue(
        entityTable: 'AllergenTags',
        entityId: tag.id,
        operation: 'insert',
        payload: {'profile_id': widget.profileId, 'label': tag.label},
      );
    }
    if (!mounted) return;
    _controller.clear();
    setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Allergies and exclusions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            const Text(
              'These ingredients are filtered out before a plan is scored.',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Ingredient to exclude',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _add,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add exclusion',
                ),
              ],
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<AllergenTag>>(
              future: _allergens,
              builder: (context, snapshot) {
                final tags = snapshot.data ?? const <AllergenTag>[];
                if (tags.isEmpty) return const Text('No exclusions added yet.');
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags
                      .map(
                        (tag) => InputChip(
                          label: Text(tag.label),
                          onDeleted: () async {
                            await ref
                                .read(profileDaoProvider)
                                .removeAllergen(tag.id);
                            await SyncQueueRepository(
                              ref.read(databaseProvider),
                            ).enqueue(
                              entityTable: 'AllergenTags',
                              entityId: tag.id,
                              operation: 'delete',
                              payload: {'profile_id': widget.profileId},
                            );
                            if (!mounted) return;
                            setState(_load);
                          },
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
