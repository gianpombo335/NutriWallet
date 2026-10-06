import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/auth_screen.dart';
import '../../features/dish_library/add_dish_screen.dart';
import '../../features/dish_library/dish_capture_screen.dart';
import '../../features/dish_library/dish_detail_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/meal_planner/plan_history_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile_setup/profile_setup_screen.dart';
import '../../features/profile_setup/profile_edit_screen.dart';
import '../../features/splash/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRefresh = _AuthRefreshNotifier();
  ref.onDispose(authRefresh.dispose);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authRefresh,
    redirect: (_, state) {
      final path = state.uri.path;
      final requiresAuth =
          path == '/setup' ||
          path == '/profile/edit' ||
          path == '/home' ||
          path.startsWith('/dishes') ||
          path.startsWith('/plans');
      if (requiresAuth &&
          Supabase.instance.client.auth.currentSession == null) {
        return '/auth';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
      GoRoute(path: '/setup', builder: (_, _) => const ProfileSetupScreen()),
      GoRoute(
        path: '/profile/edit',
        builder: (_, _) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: '/plans/history',
        builder: (_, _) => const PlanHistoryScreen(),
      ),
      GoRoute(
        path: '/plans/history/:id',
        builder: (_, state) {
          final planId = int.tryParse(state.pathParameters['id'] ?? '');
          return planId == null
              ? const _InvalidRouteScreen()
              : PlanHistoryDetailScreen(planId: planId);
        },
      ),
      GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/dishes/new', builder: (_, _) => const AddDishScreen()),
      GoRoute(
        path: '/dishes/capture',
        builder: (_, _) => const DishCaptureScreen(),
      ),
      GoRoute(
        path: '/dishes/:id/edit',
        builder: (_, state) {
          final dishId = int.tryParse(state.pathParameters['id'] ?? '');
          return dishId == null
              ? const _InvalidRouteScreen()
              : AddDishScreen(dishId: dishId);
        },
      ),
      GoRoute(
        path: '/dishes/:id',
        builder: (_, state) {
          final dishId = int.tryParse(state.pathParameters['id'] ?? '');
          return dishId == null
              ? const _InvalidRouteScreen()
              : DishDetailScreen(dishId: dishId);
        },
      ),
    ],
  );
});

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier() {
    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

class _InvalidRouteScreen extends StatelessWidget {
  const _InvalidRouteScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Page not found.')));
  }
}
