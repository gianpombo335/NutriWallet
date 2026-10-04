import 'package:drift/drift.dart';

import '../database.dart';

part 'nutrition_cache_dao.g.dart';

@DriftAccessor(tables: [NutritionCaches])
class NutritionCacheDao extends DatabaseAccessor<AppDatabase>
    with _$NutritionCacheDaoMixin {
  NutritionCacheDao(super.db);

  Future<NutritionCache?> findByName(String normalizedName) => (select(
    nutritionCaches,
  )..where((row) => row.name.equals(normalizedName))).getSingleOrNull();

  Future<void> save({
    required String name,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    int? usdaFdcId,
  }) async {
    await into(nutritionCaches).insertOnConflictUpdate(
      NutritionCachesCompanion.insert(
        name: name,
        calories: calories,
        proteinG: proteinG,
        carbsG: carbsG,
        fatG: fatG,
        usdaFdcId: Value(usdaFdcId),
        cachedAt: DateTime.now().toUtc(),
      ),
    );
  }
}
