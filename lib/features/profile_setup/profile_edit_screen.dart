import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';
import '../../data/remote/sync_service.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _budgetController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  Set<int> _activeDays = {1, 2, 3, 4, 5, 6, 7};
  int _mealsPerDay = 3;
  String _goal = 'balanced';
  String _activity = 'moderate';
  String _sex = 'male';
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _budgetController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _load(UserProfile profile) {
    if (_loaded) return;
    _loaded = true;
    _budgetController.text = (profile.weeklyBudgetCents / 100).toStringAsFixed(
      2,
    );
    _weightController.text = profile.weightKg?.toString() ?? '';
    _heightController.text = profile.heightCm?.toString() ?? '';
    _ageController.text = profile.age?.toString() ?? '';
    _activeDays = profile.activeDays
        .split(',')
        .map(int.tryParse)
        .whereType<int>()
        .toSet();
    if (_activeDays.isEmpty) _activeDays = {1, 2, 3, 4, 5, 6, 7};
    _mealsPerDay = profile.mealsPerDay;
    _goal = profile.goalPreset;
    _activity = profile.activityLevel;
    _sex = profile.sex ?? 'male';
  }

  Future<void> _save(UserProfile profile) async {
    final budget = double.tryParse(_budgetController.text);
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    final age = int.tryParse(_ageController.text);
    if (budget == null || budget < 0 || _activeDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid budget and select a day.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final profileDao = ref.read(profileDaoProvider);
      await profileDao.updateProfile(
        UserProfilesCompanion(
          id: Value(profile.id),
          weeklyBudgetCents: Value((budget * 100).round()),
          activeDays: Value((_activeDays.toList()..sort()).join(',')),
          mealsPerDay: Value(_mealsPerDay),
          weightKg: Value(weight),
          heightCm: Value(height),
          age: Value(age),
          sex: Value(_sex),
          activityLevel: Value(_activity),
          goalPreset: Value(_goal),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      final savedProfile = await profileDao.findById(profile.id);
      if (savedProfile != null) {
        await SyncQueueRepository(ref.read(databaseProvider)).enqueue(
          entityTable: 'UserProfiles',
          entityId: savedProfile.id,
          operation: 'update',
          payload: userProfileSyncPayload(savedProfile),
          dirtyAt: savedProfile.updatedAt,
        );
      }
      ref.invalidate(currentProfileProvider);
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save your profile. Try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider).value;
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _load(profile);
    final currency = ref.watch(currencyProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          Text(
            'Budget and schedule',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Weekly food budget',
              prefixText: '${currency.symbol} ',
            ),
          ),
          const SizedBox(height: AppSpacing.item),
          DropdownButtonFormField<int>(
            initialValue: _mealsPerDay,
            decoration: const InputDecoration(labelText: 'Meals per day'),
            items: [2, 3, 4, 5]
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text('$value meals'),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _mealsPerDay = value ?? 3),
          ),
          const SizedBox(height: AppSpacing.item),
          Text('Active days', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [1, 2, 3, 4, 5, 6, 7]
                .map(
                  (day) => FilterChip(
                    label: Text(_dayLabel(day)),
                    selected: _activeDays.contains(day),
                    onSelected: (selected) => setState(() {
                      if (selected) {
                        _activeDays.add(day);
                      } else {
                        _activeDays.remove(day);
                      }
                    }),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.section),
          Text(
            'Nutrition direction',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _goal,
            decoration: const InputDecoration(labelText: 'Nutrition goal'),
            items: const [
              DropdownMenuItem(value: 'balanced', child: Text('Balanced')),
              DropdownMenuItem(value: 'cutting', child: Text('Cutting')),
              DropdownMenuItem(value: 'bulking', child: Text('Bulking')),
              DropdownMenuItem(
                value: 'high_protein',
                child: Text('High protein'),
              ),
              DropdownMenuItem(value: 'keto', child: Text('Keto')),
            ],
            onChanged: (value) => setState(() => _goal = value ?? 'balanced'),
          ),
          const SizedBox(height: AppSpacing.item),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
          ),
          const SizedBox(height: AppSpacing.item),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Height (cm)'),
          ),
          const SizedBox(height: AppSpacing.item),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Age'),
          ),
          const SizedBox(height: AppSpacing.item),
          DropdownButtonFormField<String>(
            initialValue: _sex,
            decoration: const InputDecoration(
              labelText: 'Sex used for BMR estimate',
            ),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (value) => setState(() => _sex = value ?? 'male'),
          ),
          const SizedBox(height: AppSpacing.item),
          DropdownButtonFormField<String>(
            initialValue: _activity,
            decoration: const InputDecoration(labelText: 'Activity level'),
            items: const [
              DropdownMenuItem(value: 'sedentary', child: Text('Sedentary')),
              DropdownMenuItem(value: 'light', child: Text('Lightly active')),
              DropdownMenuItem(
                value: 'moderate',
                child: Text('Moderately active'),
              ),
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(
                value: 'very_active',
                child: Text('Very active'),
              ),
            ],
            onChanged: (value) =>
                setState(() => _activity = value ?? 'moderate'),
          ),
          const SizedBox(height: AppSpacing.section),
          FilledButton(
            onPressed: _saving ? null : () => _save(profile),
            child: Text(_saving ? 'Saving...' : 'Save profile'),
          ),
        ],
      ),
    );
  }

  String _dayLabel(int day) => const {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  }[day]!;
}
