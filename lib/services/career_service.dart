import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/career.dart';

class CareerService {
  final String baseUrl = 'http://20.251.152.247/career_in_technology/ctech-web/api';

  Future<List<Career>> fetchCareers() async {
    try {
      print('Fetching careers from: $baseUrl/career_profiles.php');
      final response = await http.get(Uri.parse('$baseUrl/career_profiles.php'));
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);
          print('Decoded response: $decoded');
          
          if (decoded is List) {
            final careers = decoded.map((json) => Career.fromJson(json)).toList();
            print('Parsed ${careers.length} careers');
            return careers;
          } else if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
            final data = decoded['data'];
            if (data is List) {
              final careers = data.map((json) => Career.fromJson(json)).toList();
              print('Parsed ${careers.length} careers from data field');
              return careers;
            }
          }
          print('Unexpected data format: ${response.body}');
          throw Exception('Unexpected data format: ${response.body}');
        } catch (e) {
          print('JSON parsing error: $e');
          print('Response body: ${response.body}');
          throw Exception('Failed to parse careers: Invalid JSON format');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load careers: Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<void> addCareer(Career career) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_career.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(career.toJson()),
      );

      if (response.statusCode != 200) {
        print('HTTP Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add career: Server returned ${response.statusCode}');
      }

      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
          throw Exception(decoded['error']);
        }
      } catch (e) {
        print('JSON parsing error: $e');
        print('Response body: ${response.body}');
        throw Exception('Failed to parse server response');
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }
} 