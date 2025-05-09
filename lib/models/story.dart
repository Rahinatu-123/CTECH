class Story {
  final int id;
  final String name;
  final String role;
  final String company;
  final String imagePath;
  final String shortQuote;
  final String fullStory;

  Story({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.imagePath,
    required this.shortQuote,
    required this.fullStory,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? 'Unknown',
      role: json['role'] ?? 'Unknown',
      company: json['company'] ?? 'Unknown',
      imagePath: json['image_path'] ?? '',
      shortQuote: json['short_quote'] ?? '',
      fullStory: json['full_story'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'company': company,
      'image_path': imagePath,
      'short_quote': shortQuote,
      'full_story': fullStory,
    };
  }
}
