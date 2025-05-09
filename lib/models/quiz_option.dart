class QuizOption {
  final String text;
  final bool isCorrect;

  QuizOption({
    required this.text,
    required this.isCorrect,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      text: json['text'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'is_correct': isCorrect,
    };
  }
}
