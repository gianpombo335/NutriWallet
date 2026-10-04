import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/core/currency/app_currency.dart';

void main() {
  test('supports Philippine peso formatting', () {
    final peso = currencyForCode('PHP');

    expect(peso.symbol, '₱');
    expect(peso.formatCents(1250), '₱12.50');
  });

  test('unknown currency codes safely fall back to USD', () {
    expect(currencyForCode('unknown').code, 'USD');
  });
}
