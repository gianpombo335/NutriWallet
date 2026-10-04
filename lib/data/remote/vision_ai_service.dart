import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class RecognizedDish {
  const RecognizedDish({
    required this.ingredients,
    this.mealName,
    this.cuisine,
    this.allergens = const [],
  });

  final List<String> ingredients;
  final String? mealName;
  final String? cuisine;
  final List<String> allergens;
}

abstract interface class VisionAiService {
  Future<RecognizedDish> recognizeIngredients(String imagePath);
}

class SupabaseEdgeVisionAiService implements VisionAiService {
  SupabaseEdgeVisionAiService({
    required this.dio,
    required this.edgeFunctionEndpoint,
  });

  final Dio dio;
  final String edgeFunctionEndpoint;

  @override
  Future<RecognizedDish> recognizeIngredients(String imagePath) async {
    final response = await dio.post<Map<String, dynamic>>(
      edgeFunctionEndpoint,
      data: {
        'image_base64': base64Encode(await File(imagePath).readAsBytes()),
        'mime_type': _mimeType(imagePath),
      },
    );
    final data = response.data ?? const <String, dynamic>{};
    return RecognizedDish(
      ingredients: (data['ingredients'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      mealName: data['meal_name'] as String?,
      cuisine: data['cuisine'] as String?,
      allergens: (data['allergens'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
    );
  }

  String _mimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    return switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }
}
