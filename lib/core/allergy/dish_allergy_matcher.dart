class DishAllergyMatch {
  const DishAllergyMatch({required this.exclusion, required this.source});

  final String exclusion;
  final String source;
}

List<DishAllergyMatch> findDishAllergyMatches({
  required String dishName,
  required Iterable<String> ingredients,
  required Iterable<String> exclusions,
}) {
  final searchable = <String>[
    dishName,
    ...ingredients,
  ].map((value) => value.trim()).where((value) => value.isNotEmpty).toList();
  final matches = <DishAllergyMatch>[];
  for (final exclusion in exclusions) {
    final normalized = _words(exclusion);
    if (normalized.isEmpty) continue;
    final source = searchable.cast<String?>().firstWhere(
      (value) => _containsPhrase(value!, normalized),
      orElse: () => null,
    );
    if (source != null) {
      matches.add(
        DishAllergyMatch(exclusion: exclusion.trim(), source: source),
      );
    }
  }
  return matches;
}

String _words(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();

bool _containsPhrase(String source, String phrase) {
  final sourceWords = _words(source).split(' ');
  final phraseWords = phrase.split(' ');
  if (sourceWords.isEmpty || phraseWords.isEmpty) return false;
  for (
    var index = 0;
    index <= sourceWords.length - phraseWords.length;
    index++
  ) {
    var matches = true;
    for (var offset = 0; offset < phraseWords.length; offset++) {
      if (sourceWords[index + offset] != phraseWords[offset]) {
        matches = false;
        break;
      }
    }
    if (matches) return true;
  }
  return false;
}

bool dishMatchesAllergy({
  required String dishName,
  required Iterable<String> ingredients,
  required Iterable<String> exclusions,
}) => findDishAllergyMatches(
  dishName: dishName,
  ingredients: ingredients,
  exclusions: exclusions,
).isNotEmpty;
