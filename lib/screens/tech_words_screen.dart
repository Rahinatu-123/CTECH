import 'package:flutter/material.dart';
import '../services/tech_words_service.dart';
import '../models/tech_word.dart';
// import '../../services/api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class TechWordsScreen extends StatefulWidget {
  const TechWordsScreen({Key? key}) : super(key: key);

  @override
  _TechWordsScreenState createState() => _TechWordsScreenState();
}

class _TechWordsScreenState extends State<TechWordsScreen> {
  // final ApiService _apiService = ApiService();
  final _wordController = TextEditingController();
  final _meaningController = TextEditingController();
  final _exampleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future<List<TechWord>> _futureTechWords;
  final bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _futureTechWords = TechWordsService().fetchTechWords();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _exampleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _showAddWordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Tech Word'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _wordController,
                labelText: 'Word',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a word';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _meaningController,
                labelText: 'Meaning',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the meaning';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _exampleController,
                labelText: 'Example',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an example';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _categoryController,
                labelText: 'Category',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Add',
            isLoading: _isSubmitting,
            onPressed: _submitTechWord,
          ),
        ],
      ),
    );
  }

  Future<void> _submitTechWord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final word = TechWord(
      id: DateTime.now().millisecondsSinceEpoch,
      word: _wordController.text,
      meaning: _meaningController.text,
      example: _exampleController.text,
      category: _categoryController.text,
    );

    setState(() {
      _futureTechWords = Future.value([word]);
      _isSubmitting = false;
    });

    if (!mounted) return;
    Navigator.pop(context);
    _wordController.clear();
    _meaningController.clear();
    _exampleController.clear();
    _categoryController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tech word added successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Words'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<TechWord>>(
        future: _futureTechWords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final techWords = snapshot.data ?? [];

          if (techWords.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No tech words available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the + button to add new tech words',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  if (snapshot.hasError) ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureTechWords = TechWordsService().fetchTechWords();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: techWords.length,
                  itemBuilder: (context, index) {
                    final word = techWords[index];
                    return Card(
                      margin: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                radius: 20,
                                child: Text(word.word[0].toUpperCase()),
                              ),
                              title: Text(
                                word.word,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Text(word.category.isEmpty ? 'General' : word.category),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meaning:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    word.meaning,
                                    style: const TextStyle(fontSize: 16, height: 1.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Example:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    word.example,
                                    style: const TextStyle(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  pageSnapping: true,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  techWords.length,
                  (index) => Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWordDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
