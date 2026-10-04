// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_cache_dao.dart';

// ignore_for_file: type=lint
mixin _$NutritionCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $NutritionCachesTable get nutritionCaches => attachedDatabase.nutritionCaches;
  NutritionCacheDaoManager get managers => NutritionCacheDaoManager(this);
}

class NutritionCacheDaoManager {
  final _$NutritionCacheDaoMixin _db;
  NutritionCacheDaoManager(this._db);
  $$NutritionCachesTableTableManager get nutritionCaches =>
      $$NutritionCachesTableTableManager(
        _db.attachedDatabase,
        _db.nutritionCaches,
      );
}
