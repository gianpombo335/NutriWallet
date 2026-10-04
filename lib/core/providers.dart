import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local/daos/profile_dao.dart';
import '../data/local/daos/dish_dao.dart';
import '../data/local/database.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/dish_repository.dart';
import '../data/repositories/meal_plan_repository.dart';
import '../data/repositories/budget_repository.dart';
import '../data/remote/nutrition_lookup_service.dart';
import '../data/remote/vision_ai_service.dart';
import '../data/remote/sync_service.dart';
import '../data/remote/smart_plan_service.dart';
import '../features/notifications/notification_service.dart';
import '../features/notifications/background_plan_scheduler.dart';

import 'package:workmanager/workmanager.dart';

import 'currency/app_currency.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError('SharedPreferences must be overridden in main');
});

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.persistent();
  ref.onDispose(database.close);
  return database;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository(Supabase.instance.client);
});

final profileDaoProvider = Provider<ProfileDao>((ref) {
  return ProfileDao(ref.watch(databaseProvider));
});

final dishDaoProvider = Provider<DishDao>((ref) {
  return DishDao(ref.watch(databaseProvider));
});

final dishRepositoryProvider = Provider<DishRepository>((ref) {
  return DishRepository(ref.watch(databaseProvider));
});

final mealPlanRepositoryProvider = Provider<MealPlanRepository>((ref) {
  return MealPlanRepository(ref.watch(databaseProvider));
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref.watch(databaseProvider));
});

final nutritionLookupServiceProvider = Provider<NutritionLookupService>((ref) {
  return CachingNutritionLookupService(
    database: ref.watch(databaseProvider),
    source: UsdaProxyNutritionLookupService(
      dio: _supabaseDio(),
      proxyEndpoint: '$_supabaseUrl/functions/v1/nutrition-lookup',
    ),
  );
});

final visionAiServiceProvider = Provider<VisionAiService>((ref) {
  return SupabaseEdgeVisionAiService(
    dio: _supabaseDio(),
    edgeFunctionEndpoint: '$_supabaseUrl/functions/v1/vision-recognize',
  );
});

final smartPlanServiceProvider = Provider<SmartPlanService>((ref) {
  return GeminiSmartPlanService(
    dio: _supabaseDio(),
    endpoint: '$_supabaseUrl/functions/v1/plan-generate',
  );
});

final syncEndpointProvider = Provider<SyncRemoteEndpoint>((ref) {
  return SupabaseSyncEndpoint(
    dio: _supabaseDio(),
    endpoint: '$_supabaseUrl/functions/v1/sync-push',
  );
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    database: ref.watch(databaseProvider),
    endpoint: ref.watch(syncEndpointProvider),
  );
});

final connectivitySyncCoordinatorProvider =
    Provider<ConnectivitySyncCoordinator>((ref) {
      final coordinator = ConnectivitySyncCoordinator(
        syncService: ref.watch(syncServiceProvider),
        connectivity: ConnectivityStatusAdapter(Connectivity()),
      );
      unawaited(coordinator.start());
      ref.onDispose(coordinator.dispose);
      return coordinator;
    });

final mealReminderSchedulerProvider = Provider<MealReminderScheduler>((ref) {
  return LocalMealReminderScheduler();
});

final notificationPreferencesProvider = Provider<NotificationPreferences>((
  ref,
) {
  return NotificationPreferences(ref.watch(sharedPreferencesProvider));
});

final currencyPreferencesProvider = Provider<CurrencyPreferences>((ref) {
  return CurrencyPreferences(ref.watch(sharedPreferencesProvider));
});

final currencyCodeProvider = StateProvider<String>((ref) {
  try {
    return ref.read(currencyPreferencesProvider).code;
  } catch (_) {
    return 'USD';
  }
});

final currencyProvider = Provider<AppCurrency>((ref) {
  return currencyForCode(ref.watch(currencyCodeProvider));
});

final backgroundPlanSchedulerProvider = Provider<BackgroundPlanScheduler>((
  ref,
) {
  return BackgroundPlanScheduler(Workmanager());
});

final currentProfileProvider = FutureProvider<UserProfile?>((ref) {
  final email = ref.watch(authRepositoryProvider).currentEmail;
  if (email == null) return null;
  return ref.watch(profileDaoProvider).findByEmail(email);
});

final _supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
final _supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

Dio _supabaseDio() {
  final dio = Dio(
    BaseOptions(
      headers: {'Content-Type': 'application/json', 'apikey': _supabaseAnonKey},
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final accessToken =
            Supabase.instance.client.auth.currentSession?.accessToken;
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        handler.next(options);
      },
    ),
  );
  return dio;
}
