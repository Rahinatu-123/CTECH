import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';

class StoriesService {
  final String apiUrl = 'http://20.251.152.247/career_in_technology/ctech-web/api/inspiring_stories.php';

  Future<List<Story>> fetchStories() async {
    final response = await http.get(Uri.parse(apiUrl));
    
    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map((json) => Story.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected data format: not a list');
        }
      } catch (e) {
        print('JSON parsing error: $e');
        throw Exception('Failed to parse stories');
      }
    } else {
      throw Exception('Failed to load stories: ${response.statusCode}');
    }
  }
} 