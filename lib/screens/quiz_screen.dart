import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import '../models/quiz_question.dart';
import '../models/quiz_option.dart';
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

  void _selectAnswer(QuizOption option) {
    setState(() {
      _answers[_questions[_currentQuestionIndex].id] = option.text;

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _submitQuiz();
      }
    });
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Career Quiz',
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.04,
              vertical: screenSize.height * 0.02,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${((_currentQuestionIndex + 1) / _questions.length * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.01),
                LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questions.length,
                  minHeight: screenSize.height * 0.01,
                ),
              ],
            ),
          ),

          // Question
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _questions[_currentQuestionIndex].question,
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.045 : screenSize.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  ..._questions[_currentQuestionIndex].options.map((option) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: screenSize.height * 0.01),
                      child: _buildOptionButton(
                        context,
                        option,
                        screenSize,
                        isSmallScreen,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(screenSize.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  OutlinedButton(
                    onPressed: _previousQuestion,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.04,
                        vertical: screenSize.height * 0.015,
                      ),
                    ),
                    child: Text(
                      'Previous',
                      style: TextStyle(
                        fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.04,
                      vertical: screenSize.height * 0.015,
                    ),
                  ),
                  child: Text(
                    _currentQuestionIndex == _questions.length - 1 ? 'Finish' : 'Next',
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    QuizOption option,
    Size screenSize,
    bool isSmallScreen,
  ) {
    final isSelected = _answers[_questions[_currentQuestionIndex].id] == option.text;
    
    return InkWell(
      onTap: () => _selectAnswer(option),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenSize.width * 0.04),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: screenSize.width * 0.002,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: screenSize.width * 0.05,
              height: screenSize.width * 0.05,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400]!,
                  width: screenSize.width * 0.002,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: screenSize.width * 0.04,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
            SizedBox(width: screenSize.width * 0.04),
            Expanded(
              child: Text(
                option.text,
                style: TextStyle(
                  fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.black87,
                ),
              ),
            ),
          ],
        ),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.celebration,
                size: 40,
                color: Colors.amber,
              ),
              const SizedBox(height: 12),
              Text(
                'Your Results Are Ready!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                result.message ??
                    'Based on your responses, here are the tech careers that might interest you:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: result.careers.length,
                  itemBuilder: (context, index) {
                    final career = result.careers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                'https://source.unsplash.com/random/400x300/?${(career['title'] ?? 'career').replaceAll(' ', '+')}',
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 160,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      _getCareerIcon(career['title'] ?? ''),
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    career['title'] ?? 'Unknown Career',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    career['description'] ?? 'No description available',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
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
              const SizedBox(height: 16),
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

