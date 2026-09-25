class QuizQuestion {
  final String id;
  final String word; // Target word to find synonym for
  final String partOfSpeech; // e.g., Adjektiva, Verba, Nomina
  final List<String> options; // 4 synonym choices
  final int correctIndex; // Index of correct synonym
  final String explanation; // Why this is the correct synonym
  final String sentenceExample; // Example sentence using the target word
  final String category; // 'Indonesian' or 'English'
  final String difficulty; // 'Pemula', 'Menengah', 'Mahir'

  QuizQuestion({
    required this.id,
    required this.word,
    required this.partOfSpeech,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.sentenceExample,
    required this.category,
    required this.difficulty,
  });

  String get correctAnswer => options[correctIndex];
}

class QuizCategory {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final int totalQuestions;
  final String difficulty;

  QuizCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.totalQuestions,
    required this.difficulty,
  });
}
