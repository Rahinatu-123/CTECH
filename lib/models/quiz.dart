class Quiz {
  final int id;
  final String question;
  final List<String> options;
  final String? category;
  final int? weight;

  Quiz({
    required this.id,
    required this.question,
    required this.options,
    this.category,
    this.weight,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      question: json['question'] ?? 'Unknown question',
      options: List<String>.from(json['options'] ?? []),
      category: json['category'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'category': category,
      'weight': weight,
    };
  }
}

class QuizAnswer {
  final String question;
  final String answer;

  QuizAnswer({
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class QuizResult {
  final List<Map<String, dynamic>> careers;
  final String? message;

  QuizResult({
    required this.careers,
    this.message,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      careers: List<Map<String, dynamic>>.from(json['careers'] ?? []),
      message: json['message'],
    );
  }
} 