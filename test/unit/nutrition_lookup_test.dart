import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/remote/nutrition_lookup_service.dart';

class _CountingNutritionSource implements NutritionLookupService {
  int calls = 0;

  @override
  Future<NutritionProfile?> lookup(String ingredientName) async {
    calls++;
    return NutritionProfile(
      name: ingredientName,
      calories: 100,
      proteinG: 10,
      carbsG: 12,
      fatG: 2,
    );
  }
}

void main() {
  test(
    'nutrition results are cached and the source is not called again',
    () async {
      final database = AppDatabase();
      addTearDown(database.close);
      final source = _CountingNutritionSource();
      final service = CachingNutritionLookupService(
        database: database,
        source: source,
      );

      final first = await service.lookup('  Oats ');
      final second = await service.lookup('oats');

      expect(first!.calories, 100);
      expect(second!.proteinG, 10);
      expect(source.calls, 1);
      expect(
        await database.select(database.nutritionCaches).get(),
        hasLength(1),
      );
    },
  );
}
