import 'quiz_option.dart';

class QuizQuestion {
  final String id;
  final String question;
  final List<QuizOption> options;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((option) => QuizOption.fromJson(option as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }
}
