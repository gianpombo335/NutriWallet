import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/local/daos/profile_dao.dart';
import '../../data/local/database.dart';
import '../../data/repositories/dish_repository.dart';
import '../../data/repositories/meal_plan_repository.dart';
import '../meal_planner/domain/meal_planning_engine.dart';
import '../nutrition_goal/domain/nutrition_models.dart';

const weeklyPlanTaskName = 'nutriwallet_weekly_plan_regeneration';

class BackgroundPlanScheduler {
  BackgroundPlanScheduler(this._workmanager);

  final Workmanager _workmanager;

  Future<void> initialize() => _workmanager.initialize(_backgroundDispatcher);

  Future<void> scheduleWeeklyRegeneration() {
    return _workmanager.registerPeriodicTask(
      weeklyPlanTaskName,
      weeklyPlanTaskName,
      frequency: const Duration(days: 7),
      initialDelay: const Duration(days: 7),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  Future<void> cancelWeeklyRegeneration() =>
      _workmanager.cancelByUniqueName(weeklyPlanTaskName);
}

@pragma('vm:entry-point')
void _backgroundDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != weeklyPlanTaskName) return false;
    final database = AppDatabase.persistent();
    try {
      final preferences = await SharedPreferences.getInstance();
      final profiles = await database.select(database.userProfiles).get();
      final dishes = DishRepository(database);
      final profilesDao = ProfileDao(database);
      final plans = MealPlanRepository(database);
      for (final profile in profiles) {
        final candidates = await dishes.plannerDishes(profile.id);
        if (candidates.isEmpty) continue;
        final exclusions = (await profilesDao.allergensForProfile(profile.id))
            .map((tag) => tag.label)
            .toSet();
        final days = profile.activeDays
            .split(',')
            .map(int.tryParse)
            .whereType<int>()
            .toList();
        final activeDays = days.isEmpty ? [1, 2, 3, 4, 5, 6, 7] : days;
        final plan = const MealPlanningEngine().generateWeeklyPlan(
          dishes: candidates,
          budgetCents: profile.weeklyBudgetCents,
          nutritionTargets:
              _targetsForProfile(profile) * activeDays.length.toDouble(),
          exclusions: exclusions,
          days: activeDays,
          mealsPerDay: profile.mealsPerDay,
        );
        if (plan.assignments.length !=
                activeDays.length * profile.mealsPerDay ||
            plan.isOverBudget) {
          continue;
        }
        final previous = await plans.latestPlan(profile.id);
        await plans.savePlan(
          profileId: profile.id,
          weekStartDate: _nextWeekStart(DateTime.now()),
          plan: plan,
          planningFocus: previous?.planningFocus ?? 'balanced',
          currencyCode:
              preferences.getString('currency_code') ??
              previous?.currencyCode ??
              'USD',
        );
      }
      return true;
    } finally {
      await database.close();
    }
  });
}

NutritionTargets _targetsForProfile(UserProfile profile) {
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
  final activity = switch (profile.activityLevel) {
    'very_active' || 'veryActive' => ActivityLevel.veryActive,
    'active' => ActivityLevel.active,
    'light' => ActivityLevel.light,
    'sedentary' => ActivityLevel.sedentary,
    _ => ActivityLevel.moderate,
  };
  final goal = switch (profile.goalPreset) {
    'high_protein' || 'highProtein' => GoalPreset.highProtein,
    'cutting' => GoalPreset.cutting,
    'bulking' => GoalPreset.bulking,
    'keto' => GoalPreset.keto,
    _ => GoalPreset.balanced,
  };
  final tdee = NutritionCalculator.tdee(
    weightKg: profile.weightKg!,
    heightCm: profile.heightCm!,
    age: profile.age!,
    sex: sex,
    activityLevel: activity,
  );
  return NutritionCalculator.targetsFor(tdee: tdee, preset: goal);
}

DateTime _nextWeekStart(DateTime now) {
  final monday = DateTime.utc(now.year, now.month, now.day - (now.weekday - 1));
  return monday.add(const Duration(days: 7));
}
