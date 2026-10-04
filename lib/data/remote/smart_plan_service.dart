import 'package:dio/dio.dart';

import '../../features/meal_planner/domain/planner_models.dart';
import '../../features/nutrition_goal/domain/nutrition_models.dart';

abstract interface class SmartPlanService {
  Future<List<int>> recommendDishIds({
    required List<PlannerDish> dishes,
    required PlanningFocus focus,
    required int budgetCents,
    required NutritionTargets targets,
    required List<int> days,
    required int mealsPerDay,
    required Set<String> exclusions,
    required String currencyCode,
  });
}

List<int> validateGeminiDishIds({
  required List<dynamic> rawIds,
  required List<PlannerDish> dishes,
  required int expectedSlots,
  required Set<String> exclusions,
}) {
  final recommendation = rawIds
      .whereType<num>()
      .map((id) => id.toInt())
      .toList();
  final allowedIds = dishes
      .where((dish) => !_containsExclusion(dish, exclusions))
      .map((dish) => dish.id)
      .toSet();
  if (recommendation.length != expectedSlots ||
      recommendation.any((id) => !allowedIds.contains(id))) {
    return const [];
  }
  return recommendation;
}

bool _containsExclusion(PlannerDish dish, Set<String> exclusions) {
  final searchable = <String>[
    dish.name,
    ...dish.ingredients,
  ].join(' ').toLowerCase();
  return exclusions.any(
    (exclusion) =>
        exclusion.trim().isNotEmpty &&
        searchable.contains(exclusion.trim().toLowerCase()),
  );
}

class GeminiSmartPlanService implements SmartPlanService {
  GeminiSmartPlanService({required this.dio, required this.endpoint});

  final Dio dio;
  final String endpoint;

  @override
  Future<List<int>> recommendDishIds({
    required List<PlannerDish> dishes,
    required PlanningFocus focus,
    required int budgetCents,
    required NutritionTargets targets,
    required List<int> days,
    required int mealsPerDay,
    required Set<String> exclusions,
    required String currencyCode,
  }) async {
    Response<Map<String, dynamic>>? response;
    Object? lastError;
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        response = await dio.post<Map<String, dynamic>>(
          endpoint,
          data: {
            'focus': focus.name,
            'budget_cents': budgetCents,
            'days': days,
            'meals_per_day': mealsPerDay,
            'exclusions': exclusions.toList(),
            'currency_code': currencyCode,
            'targets': {
              'calories': targets.calories,
              'protein_g': targets.proteinG,
              'carbs_g': targets.carbsG,
              'fat_g': targets.fatG,
            },
            'attempt': attempt + 1,
            'dishes': dishes
                .map(
                  (dish) => {
                    'id': dish.id,
                    'name': dish.name,
                    'price_cents': dish.roundedPriceCents,
                    'calories': dish.calories,
                    'protein_g': dish.proteinG,
                    'carbs_g': dish.carbsG,
                    'fat_g': dish.fatG,
                    'ingredients': dish.ingredients,
                  },
                )
                .toList(),
          },
        );
        break;
      } catch (error) {
        lastError = error;
        if (attempt == 0) {
          await Future<void>.delayed(const Duration(milliseconds: 250));
        }
      }
    }
    if (response == null) {
      throw lastError ?? StateError('Gemini request failed');
    }
    final ids = response.data?['dish_ids'];
    if (ids is! List) return const [];
    final expectedSlots = days.length * mealsPerDay;
    return validateGeminiDishIds(
      rawIds: ids,
      dishes: dishes,
      expectedSlots: expectedSlots,
      exclusions: exclusions,
    );
  }
}
