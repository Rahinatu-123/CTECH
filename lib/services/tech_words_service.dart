import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tech_word.dart';
import '../mock/mock_tech_words.dart';

class TechWordsService {
  final String apiUrl = 'http://20.251.152.247/career_in_technology/ctech-web/api/tech_words.php';

  Future<List<TechWord>> fetchTechWords() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> techWordsJson;

        if (decoded is Map && decoded.containsKey('data')) {
          techWordsJson = decoded['data'] as List<dynamic>;
        } else if (decoded is List) {
          techWordsJson = decoded;
        } else {
          print('Unexpected data format: $decoded');
          return mockTechWords; // Fallback to mock data
        }

        return techWordsJson.map((json) => TechWord.fromJson(json)).toList();
      } else {
        print('API error: ${response.statusCode}');
        return mockTechWords; // Fallback to mock data
      }
    } catch (e) {
      print('Error fetching tech words: $e');
      return mockTechWords; // Fallback to mock data
    }
  }
} 