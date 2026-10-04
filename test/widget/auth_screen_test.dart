import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:nutriwallet/core/providers.dart';
import 'package:nutriwallet/data/local/daos/profile_dao.dart';
import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/repositories/auth_repository.dart';
import 'package:nutriwallet/features/auth/auth_screen.dart';

void main() {
  testWidgets(
    'confirmed signup prompts for email confirmation then signs in to setup',
    (tester) async {
      final database = AppDatabase();
      addTearDown(database.close);
      final auth = _FakeAuthRepository();
      final router = _testRouter();
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(auth),
            profileDaoProvider.overrideWithValue(ProfileDao(database)),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'new@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.ensureVisible(find.text('Create account'));
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.text('Check your inbox'), findsOneWidget);
      expect(find.text('new@example.com'), findsOneWidget);
      expect(auth.registerCalls, 1);
      expect(find.text('Profile setup destination'), findsNothing);

      await tester.tap(find.text('Resend confirmation email'));
      await tester.pumpAndSettle();
      expect(auth.resendCalls, 1);

      await tester.tap(find.text("I've confirmed — sign in"));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).first)
            .controller
            ?.text,
        'new@example.com',
      );

      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(auth.signInCalls, 1);
      expect(find.text('Profile setup destination'), findsOneWidget);
    },
  );

  testWidgets('signup rejects mismatched password confirmation', (
    tester,
  ) async {
    final database = AppDatabase();
    addTearDown(database.close);
    final auth = _FakeAuthRepository();
    final router = _testRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          profileDaoProvider.overrideWithValue(ProfileDao(database)),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'new@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.enterText(find.byType(TextFormField).at(2), 'password456');
    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match.'), findsOneWidget);
    expect(auth.registerCalls, 0);
  });

  testWidgets('sign-in with an existing profile opens the home route', (
    tester,
  ) async {
    final database = AppDatabase();
    addTearDown(database.close);
    await ProfileDao(database).save(
      UserProfilesCompanion.insert(
        email: 'returning@example.com',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final auth = _FakeAuthRepository();
    final router = _testRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          profileDaoProvider.overrideWithValue(ProfileDao(database)),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'returning@example.com',
    );
    await tester.ensureVisible(find.text('Already have an account? Sign in'));
    await tester.tap(find.text('Already have an account? Sign in'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller
          ?.text,
      'returning@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'short');
    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(auth.signInCalls, 1);
    expect(find.text('Home destination'), findsOneWidget);
  });
}

GoRouter _testRouter() => GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
    GoRoute(
      path: '/setup',
      builder: (_, _) =>
          const Scaffold(body: Text('Profile setup destination')),
    ),
    GoRoute(
      path: '/home',
      builder: (_, _) => const Scaffold(body: Text('Home destination')),
    ),
  ],
);

class _FakeAuthRepository implements AuthRepository {
  int registerCalls = 0;
  int signInCalls = 0;
  int resendCalls = 0;
  String? _currentEmail;

  @override
  String? get currentEmail => _currentEmail;

  @override
  Future<AuthResult> register(String email, String password) async {
    registerCalls++;
    return AuthResult.confirmationRequired(email.trim().toLowerCase());
  }

  @override
  Future<AuthResult> signIn(String email, String password) async {
    signInCalls++;
    _currentEmail = email.trim().toLowerCase();
    return AuthResult.success(_currentEmail!);
  }

  @override
  Future<void> resendSignupConfirmation(String email) async {
    resendCalls++;
  }

  @override
  Future<void> signOut() async {
    _currentEmail = null;
  }
}
