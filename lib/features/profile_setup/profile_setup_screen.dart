import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';
import '../../data/remote/sync_service.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _budgetController = TextEditingController(text: '75');
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  int _step = 0;
  int _mealsPerDay = 3;
  String _goal = 'balanced';
  String _activity = 'moderate';
  String _sex = 'male';
  bool _saving = false;

  @override
  void dispose() {
    _budgetController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final email = ref.read(authRepositoryProvider).currentEmail;
      if (email == null) {
        _showError('Your session expired. Please sign in again.');
        if (mounted) context.go('/auth');
        return;
      }
      final budget = double.tryParse(_budgetController.text.trim());
      if (budget == null || budget < 0) {
        _showError('Enter a valid weekly budget before continuing.');
        return;
      }
      final now = DateTime.now().toUtc();
      final profileDao = ref.read(profileDaoProvider);
      final existing = await profileDao.findByEmail(email);
      late final int profileId;
      if (existing == null) {
        profileId = await profileDao.save(
          UserProfilesCompanion.insert(
            email: email,
            weeklyBudgetCents: Value((budget * 100).round()),
            mealsPerDay: Value(_mealsPerDay),
            weightKg: Value(double.tryParse(_weightController.text)),
            heightCm: Value(double.tryParse(_heightController.text)),
            age: Value(int.tryParse(_ageController.text)),
            sex: Value(_sex),
            activityLevel: Value(_activity),
            goalPreset: Value(_goal),
            createdAt: now,
            updatedAt: now,
          ),
        );
      } else {
        profileId = existing.id;
        await profileDao.updateProfile(
          UserProfilesCompanion(
            id: Value(existing.id),
            email: Value(email),
            weeklyBudgetCents: Value((budget * 100).round()),
            mealsPerDay: Value(_mealsPerDay),
            weightKg: Value(double.tryParse(_weightController.text)),
            heightCm: Value(double.tryParse(_heightController.text)),
            age: Value(int.tryParse(_ageController.text)),
            sex: Value(_sex),
            activityLevel: Value(_activity),
            goalPreset: Value(_goal),
            updatedAt: Value(now),
          ),
        );
      }
      final savedProfile = await profileDao.findById(profileId);
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
      if (mounted) context.go('/home');
    } catch (_) {
      _showError('We could not save your profile. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _next() async {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      await _finish();
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set up your plan')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          LinearProgressIndicator(value: (_step + 1) / 3),
          const SizedBox(height: AppSpacing.section),
          Text(
            'Step ${_step + 1} of 3',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 6),
          Text(_stepTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          if (_step == 0) _budgetStep(),
          if (_step == 1) _goalStep(),
          if (_step == 2) _confirmationStep(),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _saving ? null : _next,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_step == 2 ? 'Save my profile' : 'Continue'),
          ),
          if (_step > 0)
            TextButton(
              onPressed: () => setState(() => _step--),
              child: const Text('Back'),
            ),
        ],
      ),
    );
  }

  String get _stepTitle =>
      ['Budget and schedule', 'Nutrition direction', 'Ready to plan'][_step];

  Widget _budgetStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Weekly food budget',
            prefixText: '${ref.watch(currencyProvider).symbol} ',
          ),
        ),
        const SizedBox(height: AppSpacing.item),
        DropdownButtonFormField<int>(
          initialValue: _mealsPerDay,
          decoration: const InputDecoration(labelText: 'Meals per day'),
          items: [2, 3, 4, 5]
              .map(
                (value) =>
                    DropdownMenuItem(value: value, child: Text('$value meals')),
              )
              .toList(),
          onChanged: (value) => setState(() => _mealsPerDay = value ?? 3),
        ),
      ],
    );
  }

  Widget _goalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
            DropdownMenuItem(value: 'very_active', child: Text('Very active')),
          ],
          onChanged: (value) => setState(() => _activity = value ?? 'moderate'),
        ),
      ],
    );
  }

  Widget _confirmationStep() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_outline, size: 42),
            const SizedBox(height: 12),
            Text(
              'Your setup is ready.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'You can change these choices any time in Settings. Add a few dishes next, then generate a plan when the planner is enabled.',
            ),
          ],
        ),
      ),
    );
  }
}
