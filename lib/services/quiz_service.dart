import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';
import '../models/quiz_option.dart';

class QuizService {
  final String baseUrl = 'http://20.251.152.247/career_in_technology/ctech-web/api';
  final String questionsEndpoint = '/quiz_questions.php';
  final String submitEndpoint = '/submit_quiz.php';

  Future<List<QuizQuestion>> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$questionsEndpoint'));
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map((json) => QuizQuestion.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Unexpected data format: not a list');
        }
      } else {
        throw Exception('Failed to load quiz questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quiz questions: $e');
      // Return mock questions for testing
      return [
        QuizQuestion(
          id: '1',
          question: 'Which school subject do you enjoy the most?',
          options: [
            QuizOption(text: 'Art or Design', isCorrect: false),
            QuizOption(text: 'Math or Science', isCorrect: false),
            QuizOption(text: 'Literature or Languages', isCorrect: false),
            QuizOption(text: 'Social Studies or Business', isCorrect: false),
          ],
        ),
      ];
    }
  }

  Future<Map<String, dynamic>> submitQuiz(Map<String, String> answers) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$submitEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode({
          'answers': answers,
          'user_id': 'test_user', // Add any user identification if needed
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        print('Server response: ${response.body}');
        throw Exception('Failed to submit quiz: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting quiz: $e');
      // Return mock result for testing
      return {
        'message': 'Based on your responses, here are some tech careers that might interest you:',
        'careers': [
          {
            'title': 'Software Developer',
            'description': 'Design and build computer programs and applications.',
          },
          {
            'title': 'Data Scientist',
            'description': 'Analyze and interpret complex data sets.',
          },
          {
            'title': 'UX Designer',
            'description': 'Create user-friendly interfaces and experiences.',
          },
        ],
      };
    }
  }
}