import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/core/allergy/dish_allergy_matcher.dart';

void main() {
  test('matches saved exclusions against dish names and ingredients', () {
    final matches = findDishAllergyMatches(
      dishName: 'Breakfast bowl',
      ingredients: const ['oats', 'peanut butter'],
      exclusions: const ['peanut', 'shellfish'],
    );

    expect(matches, hasLength(1));
    expect(matches.single.exclusion, 'peanut');
    expect(matches.single.source, 'peanut butter');
  });

  test('ignores empty exclusions and case differences', () {
    final matches = findDishAllergyMatches(
      dishName: 'Tofu salad',
      ingredients: const ['TOFU'],
      exclusions: const ['', 'dairy'],
    );

    expect(matches, isEmpty);
  });

  test(
    'does not treat a substring inside another word as an allergy match',
    () {
      final matches = findDishAllergyMatches(
        dishName: 'Coconut curry',
        ingredients: const ['rice'],
        exclusions: const ['nut'],
      );

      expect(matches, isEmpty);
    },
  );
}
