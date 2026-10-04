import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/preference_keys.dart';
import '../../core/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 500), _routeUser);
  }

  Future<void> _routeUser() async {
    if (!mounted) return;
    final email = ref.read(authRepositoryProvider).currentEmail;
    if (email == null) {
      final hasCompletedOnboarding =
          ref
              .read(sharedPreferencesProvider)
              .getBool(onboardingCompletedPreferenceKey) ??
          false;
      context.go(hasCompletedOnboarding ? '/auth' : '/onboarding');
      return;
    }
    final profile = await ref.read(profileDaoProvider).findByEmail(email);
    if (!mounted) return;
    context.go(profile == null ? '/setup' : '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.eco_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'NutriWallet',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            const Text('Plan well. Spend wisely. Eat better.'),
          ],
        ),
      ),
    );
  }
}
