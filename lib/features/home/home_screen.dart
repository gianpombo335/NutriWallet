import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/currency/app_currency.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';
import '../budget/budget_screen.dart';
import '../dish_library/dish_library_screen.dart';
import '../meal_planner/weekly_plan_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider);
    final currency = ref.watch(currencyProvider);
    if (profile.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (profile.hasError || profile.value == null) {
      return const _ProfileRequiredState();
    }
    final pages = const [
      DishLibraryScreen(),
      WeeklyPlanScreen(),
      BudgetScreen(),
      SettingsScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            tooltip: 'Add dish',
            onPressed: () => context.push('/dishes/new'),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedIndex == 0)
            _DashboardBanner(profile: profile.value, currency: currency),
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/dishes/new'),
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Add dish'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Dishes',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  static const _titles = [
    'Dish library',
    'Weekly plan',
    'Budget tracker',
    'Settings',
  ];
}

class _ProfileRequiredState extends StatelessWidget {
  const _ProfileRequiredState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finish your profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.page),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline, size: 56),
              const SizedBox(height: 16),
              const Text(
                'Set up your profile before using your dish library and plan.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.go('/setup'),
                child: const Text('Set up profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardBanner extends StatelessWidget {
  const _DashboardBanner({required this.profile, required this.currency});

  final UserProfile? profile;
  final AppCurrency currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        4,
        AppSpacing.page,
        AppSpacing.item,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0x334B8F6A),
            child: Icon(Icons.spa, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This week starts here',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Budget available: ${currency.formatCents(profile?.weeklyBudgetCents ?? 0)}',
                  style: const TextStyle(color: Color(0xFFDDEBE3)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
