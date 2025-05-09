import 'package:flutter/material.dart';
import '../models/story.dart';
import '../services/stories_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _companyController = TextEditingController();
  final _imagePathController = TextEditingController();
  final _shortQuoteController = TextEditingController();
  final _fullStoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final StoriesService _storiesService = StoriesService();
  late Future<List<Story>> _futureStories;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _futureStories = _storiesService.fetchStories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _companyController.dispose();
    _imagePathController.dispose();
    _shortQuoteController.dispose();
    _fullStoryController.dispose();
    super.dispose();
  }

  void _showAddStoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Career Story'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Name',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the name' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _roleController,
                  labelText: 'Role',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the role' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _companyController,
                  labelText: 'Company',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the company' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _imagePathController,
                  labelText: 'Image Asset Path',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the image path' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _shortQuoteController,
                  labelText: 'Short Quote',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a short quote' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _fullStoryController,
                  labelText: 'Full Story',
                  maxLines: 4,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the story' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Save',
            isLoading: _isSubmitting,
            onPressed: _submitStory,
          ),
        ],
      ),
    );
  }

  Future<void> _submitStory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final story = Story(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text,
      role: _roleController.text,
      company: _companyController.text,
      imagePath: _imagePathController.text,
      shortQuote: _shortQuoteController.text,
      fullStory: _fullStoryController.text,
    );

    setState(() {
      _futureStories = Future.value([story]);
      _isSubmitting = false;
    });

    if (!mounted) return;
    Navigator.pop(context);

    _nameController.clear();
    _roleController.clear();
    _companyController.clear();
    _imagePathController.clear();
    _shortQuoteController.clear();
    _fullStoryController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Story shared successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Success Stories'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureStories = _storiesService.fetchStories();
          });
        },
        child: FutureBuilder<List<Story>>(
          future: _futureStories,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading stories: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureStories = _storiesService.fetchStories();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final stories = snapshot.data!;
            if (stories.isEmpty) {
              return const Center(
                child: Text('No stories available'),
              );
            }

            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return Card(
                  margin: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (story.imagePath.isNotEmpty)
                          Image.network(
                            story.imagePath,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 160,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: story.imagePath.isNotEmpty
                                ? NetworkImage(story.imagePath)
                                : null,
                            backgroundColor: Colors.grey[200],
                            child: story.imagePath.isEmpty
                                ? Text(story.name[0].toUpperCase())
                                : null,
                          ),
                          title: Text(
                            story.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text('${story.role} at ${story.company}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (story.shortQuote.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.format_quote,
                                        size: 24,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          story.shortQuote,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              Text(
                                story.fullStory,
                                style: const TextStyle(fontSize: 16, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStoryDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
