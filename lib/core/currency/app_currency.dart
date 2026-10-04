import 'package:shared_preferences/shared_preferences.dart';

class AppCurrency {
  const AppCurrency({
    required this.code,
    required this.name,
    required this.symbol,
  });

  final String code;
  final String name;
  final String symbol;

  String formatCents(int cents) => '$symbol${(cents / 100).toStringAsFixed(2)}';
}

const supportedCurrencies = <AppCurrency>[
  AppCurrency(code: 'USD', name: 'US Dollar', symbol: '\$'),
  AppCurrency(code: 'PHP', name: 'Philippine Peso', symbol: '₱'),
  AppCurrency(code: 'EUR', name: 'Euro', symbol: '€'),
  AppCurrency(code: 'GBP', name: 'British Pound', symbol: '£'),
  AppCurrency(code: 'JPY', name: 'Japanese Yen', symbol: '¥'),
];

class CurrencyPreferences {
  CurrencyPreferences(this._preferences);

  static const _key = 'currency_code';
  final SharedPreferences _preferences;

  String get code => _preferences.getString(_key) ?? 'USD';

  Future<void> setCode(String code) => _preferences.setString(_key, code);
}

AppCurrency currencyForCode(String code) => supportedCurrencies.firstWhere(
  (currency) => currency.code == code,
  orElse: () => supportedCurrencies.first,
);
