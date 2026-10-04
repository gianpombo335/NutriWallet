import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/data/local/daos/profile_dao.dart';
import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/repositories/auth_repository.dart';
import 'package:nutriwallet/data/repositories/dish_repository.dart';
import 'package:nutriwallet/data/repositories/meal_plan_repository.dart';
import 'package:nutriwallet/features/meal_planner/domain/meal_planning_engine.dart';
import 'package:nutriwallet/features/nutrition_goal/domain/nutrition_models.dart';

void main() {
  test(
    'authenticated account can create a dish and persist a generated plan',
    () async {
      final auth = SupabaseAuthRepository.withGateway(_FakeCloudAuthGateway());
      final registration = await auth.register(
        'flow@example.com',
        'password123',
      );
      expect(registration.isSuccess, isTrue);

      final database = AppDatabase();
      addTearDown(database.close);
      final profileId = await ProfileDao(database).save(
        UserProfilesCompanion.insert(
          email: registration.email!,
          weeklyBudgetCents: const Value(10000),
          mealsPerDay: const Value(2),
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        ),
      );
      final dishes = DishRepository(database);
      await dishes.createDish(
        profileId: profileId,
        name: 'Chickpea bowl',
        priceCents: 450,
        ingredients: const [
          IngredientDraft(
            name: 'chickpeas',
            calories: 269,
            proteinG: 14.5,
            carbsG: 45,
            fatG: 4.2,
          ),
        ],
      );

      final plan = const MealPlanningEngine().generateWeeklyPlan(
        dishes: await dishes.plannerDishes(profileId),
        budgetCents: 10000,
        nutritionTargets: const NutritionTargets(
          calories: 2000,
          proteinG: 150,
          carbsG: 200,
          fatG: 67,
        ),
        exclusions: const {},
        days: [1, 2, 3, 4, 5, 6, 7],
        mealsPerDay: 2,
      );
      expect(plan.assignments, isNotEmpty);

      final plans = MealPlanRepository(database);
      await plans.savePlan(
        profileId: profileId,
        weekStartDate: DateTime.utc(2026, 1, 5),
        plan: plan,
      );
      expect((await plans.latestPlan(profileId))?.version, 1);

      await auth.signOut();
      final signedIn = await auth.signIn('flow@example.com', 'password123');
      expect(signedIn.isSuccess, isTrue);
    },
  );
}

class _FakeCloudAuthGateway implements CloudAuthGateway {
  String? _email;

  @override
  String? get currentEmail => _email;

  @override
  Future<CloudAuthResponse> signUp(String email, String password) async {
    _email = email;
    return CloudAuthResponse(email: email, hasSession: true);
  }

  @override
  Future<CloudAuthResponse> signIn(String email, String password) async {
    _email = email;
    return CloudAuthResponse(email: email, hasSession: true);
  }

  @override
  Future<void> resendSignupConfirmation(String email) async {}

  @override
  Future<void> signOut() async {
    _email = null;
  }
}
