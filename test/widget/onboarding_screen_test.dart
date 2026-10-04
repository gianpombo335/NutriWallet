import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutriwallet/core/constants/preference_keys.dart';
import 'package:nutriwallet/core/providers.dart';
import 'package:nutriwallet/data/repositories/auth_repository.dart';
import 'package:nutriwallet/features/onboarding/onboarding_screen.dart';
import 'package:nutriwallet/features/splash/splash_screen.dart';

void main() {
  testWidgets('finishing onboarding remembers completion and opens auth', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (_, _) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/auth',
          builder: (_, _) => const Scaffold(body: Text('Authentication')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(preferences.getBool(onboardingCompletedPreferenceKey), isTrue);
    expect(find.text('Authentication'), findsOneWidget);
  });

  testWidgets('returning signed-out users go to auth instead of onboarding', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      onboardingCompletedPreferenceKey: true,
    });
    final preferences = await SharedPreferences.getInstance();
    final auth = _SignedOutAuthRepository();
    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
        GoRoute(
          path: '/onboarding',
          builder: (_, _) => const Scaffold(body: Text('Onboarding')),
        ),
        GoRoute(
          path: '/auth',
          builder: (_, _) => const Scaffold(body: Text('Authentication')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          authRepositoryProvider.overrideWithValue(auth),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Authentication'), findsOneWidget);
    expect(find.text('Onboarding'), findsNothing);
  });
}

class _SignedOutAuthRepository implements AuthRepository {
  @override
  String? get currentEmail => null;

  @override
  Future<AuthResult> register(String email, String password) async =>
      const AuthResult.failure('not used');

  @override
  Future<AuthResult> signIn(String email, String password) async =>
      const AuthResult.failure('not used');

  @override
  Future<void> resendSignupConfirmation(String email) async {}

  @override
  Future<void> signOut() async {}
}
