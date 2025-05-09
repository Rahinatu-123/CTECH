class Career {
  final int id;
  final String title;
  final String description;
  // final String skills;
  final List<String> skills; // Add this property
  final String education;
  final String salaryRange;
  final String jobOutlook;
  final String? imagePath;
  final String? videoPath;
  final String? audioPath;
  final String? createdAt;
  final String? updatedAt;
  final List<String>? tools;
  final String? deviceFeature;
  final String? simulationType;

  Career({
    required this.id,
    required this.title,
    required this.description,
    // required this.skills,
    required this.skills, // Initialize it here
    required this.education,
    required this.salaryRange,
    required this.jobOutlook,
    this.imagePath,
    this.videoPath,
    this.audioPath,
    this.createdAt,
    this.updatedAt,
    this.tools,
    this.deviceFeature,
    this.simulationType,
  });

  factory Career.fromJson(Map<String, dynamic> json) {
    String? getSimulationType(String title) {
      final lowercaseTitle = title.toLowerCase();
      if (lowercaseTitle.contains('ai engineer')) return 'ai_engineer';
      if (lowercaseTitle.contains('data scientist')) return 'data_scientist';
      if (lowercaseTitle.contains('cybersecurity')) return 'cybersecurity';
      if (lowercaseTitle.contains('mobile app')) return 'mobile_dev';
      if (lowercaseTitle.contains('embedded systems')) return 'iot_engineer';
      if (lowercaseTitle.contains('ui/ux') ||
          lowercaseTitle.contains('ui designer'))
        return 'ui_ux';
      if (lowercaseTitle.contains('game developer')) return 'game_dev';
      if (lowercaseTitle.contains('web developer')) return 'web_dev';
      if (lowercaseTitle.contains('devops')) return 'devops';
      if (lowercaseTitle.contains('blockchain')) return 'blockchain';
      return null;
    }

    return Career(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? 'Unknown title',
      description:
          json['description']?.toString() ?? 'No description available',
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      education: json['education']?.toString() ?? '',
      salaryRange: json['salary_range']?.toString() ?? '',
      jobOutlook: json['job_outlook']?.toString() ?? '',
      imagePath: json['image_path']?.toString(),
      videoPath: json['video_path']?.toString(),
      audioPath: json['audio_path']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      tools: (json['tools'] as List?)?.map((e) => e.toString()).toList(),
      deviceFeature: json['device_feature']?.toString(),
      simulationType: getSimulationType(json['title']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'skills': skills,
      'education': education,
      'salary_range': salaryRange,
      'job_outlook': jobOutlook,
      'image_path': imagePath,
      'video_path': videoPath,
      'audio_path': audioPath,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'tools': tools,
      'device_feature': deviceFeature,
      'simulation_type': simulationType,
    };
  }
}
