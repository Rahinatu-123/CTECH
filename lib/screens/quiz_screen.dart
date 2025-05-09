import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import '../models/career.dart';
import '../../widgets/custom_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _quizService = QuizService();
  late Future<List<QuizQuestion>> _futureQuestions;
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  final Map<String, String> _answers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _futureQuestions = _quizService.fetchQuestions();
  }

  void _selectAnswer(String answer) {
    setState(() {
      _answers[_questions[_currentQuestionIndex].id] = answer;

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _submitQuiz();
      }
    });
  }

  Future<void> _submitQuiz() async {
    setState(() => _isSubmitting = true);

    try {
      final result = await _quizService.submitQuiz(_answers);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            result: QuizResult(
              message: result['message'] as String?,
              careers: (result['careers'] as List<dynamic>)
                  .map((career) => Map<String, String>.from(career as Map))
                  .toList(),
            ),
          ),
        ),
      );
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Quiz'),
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available.'));
          }

          _questions = snapshot.data!;
          final currentQuestion = _questions[_currentQuestionIndex];

          return _isSubmitting
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Analyzing your responses...'),
                    ],
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: (_currentQuestionIndex + 1) / _questions.length,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          currentQuestion.question,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 32),
                        Expanded(
                          child: ListView.separated(
                            itemCount: currentQuestion.options.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final option = currentQuestion.options[index];
                              return CustomButton(
                                text: option.text,
                                isOutlined: true,
                                onPressed: () => _selectAnswer(option.text),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class QuizResultScreen extends StatelessWidget {
  final QuizResult result;

  const QuizResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.celebration,
                size: 64,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              Text(
                'Your Results Are Ready!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                result.message ??
                    'Based on your responses, here are the tech careers that might interest you:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: result.careers.length,
                  itemBuilder: (context, index) {
                    final career = result.careers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/career-details',
                            arguments: Career(
                              id: 0,
                              title: career['title'] ?? 'Unknown Career',
                              description: career['description'] ?? 'No description available',
                              skills: [],
                              education: '',
                              salaryRange: '',
                              jobOutlook: '',
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                'https://source.unsplash.com/random/400x300/?${(career['title'] ?? 'career').replaceAll(' ', '+')}',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      _getCareerIcon(career['title'] ?? ''),
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    career['title'] ?? 'Unknown Career',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    career['description'] ?? 'No description available',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Take Quiz Again',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCareerIcon(String title) {
    final lowercaseTitle = title.toLowerCase();
    if (lowercaseTitle.contains('developer') || lowercaseTitle.contains('programmer')) {
      return Icons.code;
    } else if (lowercaseTitle.contains('designer') || lowercaseTitle.contains('ui')) {
      return Icons.design_services;
    } else if (lowercaseTitle.contains('data') || lowercaseTitle.contains('analyst')) {
      return Icons.analytics;
    } else if (lowercaseTitle.contains('cloud') || lowercaseTitle.contains('network')) {
      return Icons.cloud;
    } else if (lowercaseTitle.contains('security')) {
      return Icons.security;
    } else if (lowercaseTitle.contains('mobile')) {
      return Icons.phone_android;
    } else {
      return Icons.computer;
    }
  }
}
