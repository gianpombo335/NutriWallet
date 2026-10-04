import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/preference_keys.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/currency/app_currency.dart';
import '../../core/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  bool _finishing = false;
  late String _currencyCode;

  final _slides = const [
    (
      'Build your own library',
      'Save the dishes you already love, with their real cost and nutrition.',
    ),
    (
      'Make your budget work harder',
      'Generate a practical week from your budget instead of guessing at checkout.',
    ),
    (
      'Stay on track',
      'Keep allergies, nutrition goals, and meal planning together in one calm place.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currencyCode = ref.read(currencyPreferencesProvider).code;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    try {
      await ref
          .read(sharedPreferencesProvider)
          .setBool(onboardingCompletedPreferenceKey, true);
      await ref.read(currencyPreferencesProvider).setCode(_currencyCode);
      ref.read(currencyCodeProvider.notifier).state = _currencyCode;
      if (mounted) context.go('/auth');
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_page];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finishing ? null : _finishOnboarding,
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemCount: _slides.length,
                  itemBuilder: (_, index) => _Slide(
                    index: index,
                    title: _slides[index].$1,
                    body: _slides[index].$2,
                  ),
                ),
              ),
              if (_page == _slides.length - 1) ...[
                const SizedBox(height: AppSpacing.item),
                Text(
                  'Which currency do you use?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _currencyCode,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.payments_outlined),
                    labelText: 'Display currency',
                  ),
                  items: supportedCurrencies
                      .map(
                        (currency) => DropdownMenuItem(
                          value: currency.code,
                          child: Text(
                            '${currency.symbol} ${currency.code} · ${currency.name}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _finishing
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _currencyCode = value);
                          }
                        },
                ),
              ],
              Row(
                children: List.generate(
                  _slides.length,
                  (index) => Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 4,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: index == _page
                            ? AppColors.primaryGreen
                            : const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              FilledButton(
                onPressed: _finishing
                    ? null
                    : () {
                        if (_page == _slides.length - 1) {
                          _finishOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                child: Text(
                  _finishing
                      ? 'Getting things ready...'
                      : _page == _slides.length - 1
                      ? 'Get started'
                      : 'Continue',
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                slide.$1,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.index, required this.title, required this.body});

  final int index;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.restaurant_menu_rounded,
      Icons.account_balance_wallet_rounded,
      Icons.favorite_rounded,
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFDDEBE3),
              borderRadius: BorderRadius.circular(48),
            ),
            child: Icon(icons[index], size: 72, color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 36),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
