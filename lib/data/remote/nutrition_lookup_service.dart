import 'package:dio/dio.dart';

import '../local/daos/nutrition_cache_dao.dart';
import '../local/database.dart';

class NutritionProfile {
  const NutritionProfile({
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.usdaFdcId,
  });

  final String name;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int? usdaFdcId;
}

abstract interface class NutritionLookupService {
  Future<NutritionProfile?> lookup(String ingredientName);
}

class CachingNutritionLookupService implements NutritionLookupService {
  CachingNutritionLookupService({
    required AppDatabase database,
    required this.source,
  }) : _cache = NutritionCacheDao(database);

  final NutritionCacheDao _cache;
  final NutritionLookupService source;

  @override
  Future<NutritionProfile?> lookup(String ingredientName) async {
    final normalized = _normalize(ingredientName);
    final cached = await _cache.findByName(normalized);
    if (cached != null) {
      return NutritionProfile(
        name: cached.name,
        calories: cached.calories,
        proteinG: cached.proteinG,
        carbsG: cached.carbsG,
        fatG: cached.fatG,
        usdaFdcId: cached.usdaFdcId,
      );
    }
    final profile = await source.lookup(normalized);
    if (profile == null) return null;
    await _cache.save(
      name: normalized,
      calories: profile.calories,
      proteinG: profile.proteinG,
      carbsG: profile.carbsG,
      fatG: profile.fatG,
      usdaFdcId: profile.usdaFdcId,
    );
    return profile;
  }
}

class UsdaProxyNutritionLookupService implements NutritionLookupService {
  UsdaProxyNutritionLookupService({
    required this.dio,
    required this.proxyEndpoint,
  });

  final Dio dio;
  final String proxyEndpoint;

  @override
  Future<NutritionProfile?> lookup(String ingredientName) async {
    final response = await dio.post<Map<String, dynamic>>(
      proxyEndpoint,
      data: {'ingredient': ingredientName},
    );
    final data = response.data;
    if (data == null) return null;
    return NutritionProfile(
      name: _normalize(ingredientName),
      calories: (data['calories'] as num?)?.toDouble() ?? 0,
      proteinG: (data['protein_g'] as num?)?.toDouble() ?? 0,
      carbsG: (data['carbs_g'] as num?)?.toDouble() ?? 0,
      fatG: (data['fat_g'] as num?)?.toDouble() ?? 0,
      usdaFdcId: (data['fdc_id'] as num?)?.toInt(),
    );
  }
}

String _normalize(String value) =>
    value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
