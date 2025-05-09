class CareerProfile {
  final String id;
  final String title;
  final String description;
  final String requirements;
  final String salary;
  final String imageUrl;

  CareerProfile({
    required this.id,
    required this.title,
    required this.description,
    required this.requirements,
    required this.salary,
    this.imageUrl = '',
  });

  factory CareerProfile.fromJson(Map<String, dynamic> json) {
    return CareerProfile(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requirements: json['requirements'] ?? '',
      salary: json['salary'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
