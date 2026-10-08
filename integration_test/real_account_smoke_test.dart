import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';

import 'package:nutriwallet/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('real account can enter the configured app shell', (
    tester,
  ) async {
    const email = String.fromEnvironment('NUTRIWALLET_TEST_EMAIL');
    const password = String.fromEnvironment('NUTRIWALLET_TEST_PASSWORD');
    expect(email, isNotEmpty);
    expect(password, isNotEmpty);

    await app.main();
    await _settle(tester, const Duration(seconds: 8));

    if (find.text('Skip').evaluate().isNotEmpty) {
      await tester.tap(find.text('Skip'));
      await _settle(tester);
    }

    if (find.text('Already have an account? Sign in').evaluate().isNotEmpty) {
      await tester.tap(find.text('Already have an account? Sign in'));
      await _settle(tester);
    }

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.at(0), email);
    await tester.enterText(fields.at(1), password);
    await tester.tap(find.text('Sign in'));
    await _settle(tester, const Duration(seconds: 10));

    if (find.text('Set up your plan').evaluate().isNotEmpty) {
      for (var step = 0; step < 2; step++) {
        await tester.tap(find.text('Continue'));
        await _settle(tester);
      }
      await tester.tap(find.text('Save my profile'));
      await _settle(tester, const Duration(seconds: 5));
    }

    expect(find.text('Dishes'), findsOneWidget);
    expect(find.text('Plan'), findsOneWidget);
    expect(find.text('Budget'), findsOneWidget);
    expect(find.text('Settings'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('Plan'));
    await _settle(tester);
    expect(find.text('Weekly plan'), findsOneWidget);

    await tester.tap(find.text('Budget'));
    await _settle(tester);
    expect(find.text('Budget tracker'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await _settle(tester);
    expect(find.text('Settings'), findsAtLeastNWidgets(1));
  });
}

Future<void> _settle(
  WidgetTester tester, [
  Duration duration = const Duration(seconds: 2),
]) async {
  final deadline = DateTime.now().add(duration);
  do {
    await tester.pump(const Duration(milliseconds: 100));
  } while (DateTime.now().isBefore(deadline));
}
