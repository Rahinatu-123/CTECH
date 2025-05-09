import 'dart:convert';

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
    print('Parsing career from JSON: $json');
    
    String? getSimulationType(String title) {
      final lowercaseTitle = title.toLowerCase();
      
      // UI/UX Design
      if (lowercaseTitle.contains('ui') || 
          lowercaseTitle.contains('ux') ||
          lowercaseTitle.contains('designer') ||
          lowercaseTitle.contains('interface') ||
          lowercaseTitle.contains('user experience') ||
          lowercaseTitle.contains('user interface')) {
        return 'ui_ux';
      }
      
      // DevOps
      if (lowercaseTitle.contains('devops') || 
          lowercaseTitle.contains('operations') ||
          lowercaseTitle.contains('deployment') ||
          lowercaseTitle.contains('ci/cd') ||
          lowercaseTitle.contains('continuous integration') ||
          lowercaseTitle.contains('continuous deployment')) {
        return 'devops';
      }
      
      // Cybersecurity
      if (lowercaseTitle.contains('security') || 
          lowercaseTitle.contains('cyber') ||
          lowercaseTitle.contains('infosec') ||
          lowercaseTitle.contains('information security') ||
          lowercaseTitle.contains('network security') ||
          lowercaseTitle.contains('security analyst')) {
        return 'cybersecurity';
      }
      
      // Mobile Development
      if (lowercaseTitle.contains('mobile') || 
          lowercaseTitle.contains('android') ||
          lowercaseTitle.contains('ios') ||
          lowercaseTitle.contains('app developer') ||
          lowercaseTitle.contains('application developer')) {
        return 'mobile_dev';
      }
      
      // Web Development
      if (lowercaseTitle.contains('web') || 
          lowercaseTitle.contains('frontend') ||
          lowercaseTitle.contains('backend') ||
          lowercaseTitle.contains('fullstack') ||
          lowercaseTitle.contains('website') ||
          lowercaseTitle.contains('web developer')) {
        return 'web_dev';
      }
      
      // Game Development
      if (lowercaseTitle.contains('game') || 
          lowercaseTitle.contains('gaming') ||
          lowercaseTitle.contains('game developer') ||
          lowercaseTitle.contains('game designer') ||
          lowercaseTitle.contains('game programmer')) {
        return 'game_dev';
      }
      
      // IoT and Embedded Systems
      if (lowercaseTitle.contains('iot') || 
          lowercaseTitle.contains('embedded') ||
          lowercaseTitle.contains('hardware') ||
          lowercaseTitle.contains('internet of things') ||
          lowercaseTitle.contains('device') ||
          lowercaseTitle.contains('sensor')) {
        return 'iot_engineer';
      }
      
      // Blockchain
      if (lowercaseTitle.contains('blockchain') || 
          lowercaseTitle.contains('crypto') ||
          lowercaseTitle.contains('web3') ||
          lowercaseTitle.contains('distributed ledger') ||
          lowercaseTitle.contains('smart contract')) {
        return 'blockchain';
      }
      
      // AI and Machine Learning
      if (lowercaseTitle.contains('ai') || 
          lowercaseTitle.contains('machine learning') ||
          lowercaseTitle.contains('artificial intelligence')) {
        return 'ai_engineer';
      }
      
      // Data Science
      if (lowercaseTitle.contains('data') && 
          (lowercaseTitle.contains('scientist') || 
           lowercaseTitle.contains('analyst') ||
           lowercaseTitle.contains('engineer'))) {
        return 'data_scientist';
      }
      
      return null;
    }

    // Handle skills field which might be a string or a list
    List<String> parseSkills(dynamic skillsData) {
      if (skillsData == null) return [];
      
      if (skillsData is List) {
        return skillsData.map((e) => e.toString()).toList();
      }
      
      if (skillsData is String) {
        // Try to parse as JSON array first
        try {
          final decoded = jsonDecode(skillsData);
          if (decoded is List) {
            return decoded.map((e) => e.toString()).toList();
          }
        } catch (e) {
          // If not valid JSON, split by comma
          return skillsData.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        }
      }
      
      return [];
    }

    try {
      final career = Career(
        id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
        title: json['title']?.toString() ?? 'Unknown title',
        description: json['description']?.toString() ?? 'No description available',
        skills: parseSkills(json['skills']),
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
      print('Successfully parsed career: ${career.title}');
      return career;
    } catch (e) {
      print('Error parsing career JSON: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
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
