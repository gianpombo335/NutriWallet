import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:nutriwallet/data/local/daos/profile_dao.dart';
import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/remote/nutrition_lookup_service.dart';
import 'package:nutriwallet/data/remote/smart_plan_service.dart';
import 'package:nutriwallet/data/remote/sync_service.dart';
import 'package:nutriwallet/data/repositories/auth_repository.dart';
import 'package:nutriwallet/data/repositories/budget_repository.dart';
import 'package:nutriwallet/data/repositories/dish_repository.dart';
import 'package:nutriwallet/data/repositories/meal_plan_repository.dart';
import 'package:nutriwallet/features/meal_planner/domain/planner_models.dart';
import 'package:nutriwallet/features/nutrition_goal/domain/nutrition_models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final email = Platform.environment['NUTRIWALLET_TEST_EMAIL'];
  final password = Platform.environment['NUTRIWALLET_TEST_PASSWORD'];
  final url = Platform.environment['SUPABASE_URL'];
  final anonKey = Platform.environment['SUPABASE_ANON_KEY'];
  final configured = [
    email,
    password,
    url,
    anonKey,
  ].every((value) => value?.trim().isNotEmpty == true);

  test(
    'connected account exercises authentication, providers, plan sync, and check-in sync',
    timeout: const Timeout(Duration(minutes: 2)),
    () async {
      SharedPreferences.setMockInitialValues({});
      await Supabase.initialize(url: url!, publishableKey: anonKey!);
      final client = Supabase.instance.client;
      final auth = SupabaseAuthRepository(client);
      final signIn = await auth.signIn(email!, password!);
      expect(signIn.isSuccess, isTrue, reason: signIn.error);

      final dio = _authenticatedDio(client, anonKey);
      final nutrition = UsdaProxyNutritionLookupService(
        dio: dio,
        proxyEndpoint: '$url/functions/v1/nutrition-lookup',
      );
      late final NutritionProfile? nutritionResult;
      try {
        nutritionResult = await nutrition.lookup('chickpeas');
      } catch (error) {
        throw StateError('Nutrition proxy failed: ${_status(error)}');
      }
      expect(nutritionResult, isNotNull);
      expect(nutritionResult!.calories, greaterThan(0));

      final smartPlan = GeminiSmartPlanService(
        dio: dio,
        endpoint: '$url/functions/v1/plan-generate',
      );
      const dishes = [
        PlannerDish(
          id: 1,
          name: 'Connected chicken bowl',
          price: 2.50,
          calories: 500,
          proteinG: 35,
          carbsG: 45,
          fatG: 12,
          ingredients: ['chicken', 'rice'],
        ),
        PlannerDish(
          id: 2,
          name: 'Connected bean salad',
          price: 1.75,
          calories: 350,
          proteinG: 18,
          carbsG: 42,
          fatG: 8,
          ingredients: ['beans', 'greens'],
        ),
      ];
      late final List<int> recommendation;
      try {
        recommendation = await smartPlan.recommendDishIds(
          dishes: dishes,
          focus: PlanningFocus.balanced,
          budgetCents: 1000,
          targets: const NutritionTargets(
            calories: 800,
            proteinG: 40,
            carbsG: 80,
            fatG: 20,
          ),
          days: const [1],
          mealsPerDay: 2,
          exclusions: const {},
          currencyCode: 'USD',
        );
      } catch (error) {
        throw StateError('Smart-plan proxy failed: ${_status(error)}');
      }
      expect(recommendation, hasLength(2));

      final database = AppDatabase();
      addTearDown(() async {
        await database.close();
        await auth.signOut();
      });
      final profileDao = ProfileDao(database);
      final profileId = await profileDao.save(
        UserProfilesCompanion.insert(
          email: email,
          weeklyBudgetCents: const Value(10000),
          mealsPerDay: const Value(2),
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      final profile = await profileDao.findById(profileId);
      expect(profile, isNotNull);
      await SyncQueueRepository(database).enqueue(
        entityTable: 'UserProfiles',
        entityId: profileId,
        operation: 'insert',
        payload: userProfileSyncPayload(profile!),
      );

      final dishRepository = DishRepository(database);
      final main = await dishRepository.createDish(
        profileId: profileId,
        name: 'Connected smoke main ${DateTime.now().millisecondsSinceEpoch}',
        priceCents: 250,
        ingredients: [
          IngredientDraft(
            name: 'chicken',
            calories: 300,
            proteinG: 30,
            carbsG: 5,
            fatG: 12,
          ),
        ],
      );
      final side = await dishRepository.createDish(
        profileId: profileId,
        name: 'Connected smoke side ${DateTime.now().millisecondsSinceEpoch}',
        priceCents: 125,
        ingredients: [
          IngredientDraft(
            name: 'rice',
            calories: 200,
            proteinG: 4,
            carbsG: 42,
            fatG: 1,
          ),
        ],
      );
      final mainDish = (await dishRepository.plannerDishes(profileId))
          .firstWhere((dish) => dish.id == main.id);
      final sideDish = (await dishRepository.plannerDishes(profileId))
          .firstWhere((dish) => dish.id == side.id);

      final plan = GeneratedMealPlan(
        assignments: [
          MealSlotAssignment(
            dayIndex: 1,
            slotIndex: 0,
            dish: mainDish,
            reason: 'connected smoke test',
            components: [
              MealSlotComponent(dish: mainDish),
              MealSlotComponent(dish: sideDish),
            ],
          ),
        ],
        totalCostCents: 375,
        isOverBudget: false,
      );
      final mealPlans = MealPlanRepository(database);
      final savedPlan = await mealPlans.savePlan(
        profileId: profileId,
        weekStartDate: _monday(DateTime.now()),
        plan: plan,
      );
      final slot = (await mealPlans.slotsForPlan(savedPlan.id)).single;
      expect(
        (await mealPlans.loadMealPlan(savedPlan))
            .assignments
            .single
            .mealComponents,
        hasLength(2),
      );

      final budget = BudgetRepository(database);
      await budget.recordMealCheckIn(
        profileId: profileId,
        planId: savedPlan.id,
        slotId: slot.id,
        mealStatus: 'eaten',
        consumedAt: DateTime.now().toUtc(),
        actualCostCents: slot.plannedCostCents,
        label: 'Connected smoke meal',
      );

      final endpoint = SupabaseSyncEndpoint(
        dio: dio,
        endpoint: '$url/functions/v1/sync-push',
      );
      late final int synced;
      try {
        synced = await SyncService(
          database: database,
          endpoint: endpoint,
        ).syncPending();
      } catch (error) {
        throw StateError('Sync proxy failed: ${_status(error)}');
      }
      expect(synced, greaterThan(0));
      expect((await SyncQueueRepository(database).pending()), isEmpty);
    },
    skip: configured
        ? false
        : 'Connected smoke credentials are not configured.',
  );
}

Dio _authenticatedDio(SupabaseClient client, String anonKey) {
  final dio = Dio(
    BaseOptions(
      headers: {'Content-Type': 'application/json', 'apikey': anonKey},
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = client.auth.currentSession?.accessToken;
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    ),
  );
  return dio;
}

DateTime _monday(DateTime value) =>
    DateTime.utc(value.year, value.month, value.day - (value.weekday - 1));

String _status(Object error) => error is DioException
    ? '${error.response?.statusCode ?? 'network'} ${error.response?.data ?? ''}'
    : 'unexpected';
