import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class NutriWalletApp extends ConsumerWidget {
  const NutriWalletApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(connectivitySyncCoordinatorProvider);
    return MaterialApp.router(
      title: 'NutriWallet',
      theme: buildAppTheme(),
      routerConfig: ref.watch(appRouterProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
