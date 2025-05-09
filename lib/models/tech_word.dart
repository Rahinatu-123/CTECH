class TechWord {
  final int id;
  final String word;
  final String meaning;
  final String example;
  final String category;

  TechWord({
    required this.id,
    required this.word,
    required this.meaning,
    required this.example,
    required this.category,
  });

  factory TechWord.fromJson(Map<String, dynamic> json) {
    return TechWord(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      word: json['word'] ?? 'Unknown word',
      meaning: json['definition'] ?? 'No definition available',
      example: 'Example will be added soon.',
      category: json['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'example': example,
      'category': category,
    };
  }
}
