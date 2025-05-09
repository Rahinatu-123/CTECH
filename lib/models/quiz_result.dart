class QuizResult {
  final String? message;
  final List<Map<String, String>> careers;

  QuizResult({
    this.message,
    required this.careers,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      message: json['message'] as String?,
      careers: (json['careers'] as List<dynamic>)
          .map((career) => Map<String, String>.from(career as Map))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'careers': careers,
    };
  }
}
