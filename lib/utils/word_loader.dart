import 'dart:math';
import 'categorized_words.dart';

class WordLoader {
  final Random random = Random();

  /// Fetch words for a specific theme
  List<String> loadWords({required String theme, int count = 10}) {
    if (!categorizedWords.containsKey(theme)) {
      throw Exception('Theme "$theme" not found in categorized words.');
    }

    // Clone the list to make it mutable
    List<String> allWords = List.from(categorizedWords[theme]!);
    allWords.shuffle(); // Shuffle the cloned list
    return allWords.take(count).toList(); // Return the requested number of words
  }

  /// Fetch a random theme
  String getRandomTheme() {
    List<String> themes = categorizedWords.keys.toList();
    return themes[random.nextInt(themes.length)];
  }
}
