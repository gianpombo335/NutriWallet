import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  return GoRouter(
    initialLocation: '/splash',
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
        builder: (_, state) => PlanHistoryDetailScreen(
          planId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/dishes/new', builder: (_, _) => const AddDishScreen()),
      GoRoute(
        path: '/dishes/capture',
        builder: (_, _) => const DishCaptureScreen(),
      ),
      GoRoute(
        path: '/dishes/:id',
        builder: (_, state) =>
            DishDetailScreen(dishId: int.parse(state.pathParameters['id']!)),
      ),
    ],
  );
});
