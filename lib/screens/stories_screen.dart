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
  final _searchController = TextEditingController();
  String _searchQuery = '';

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
    _searchController.dispose();
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
        title: const Text(
          'Success Stories',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search stories...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Story>>(
              future: _futureStories,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 40, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(
                          'Error loading stories: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
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
                final filteredStories = stories.where((story) {
                  return story.name.toLowerCase().contains(_searchQuery) ||
                      story.role.toLowerCase().contains(_searchQuery) ||
                      story.company.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredStories.isEmpty) {
                  return const Center(
                    child: Text(
                      'No stories found',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemCount: filteredStories.length,
                  itemBuilder: (context, index) {
                    final story = filteredStories[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/story-details',
                            arguments: story,
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              child: Image.network(
                                story.imagePath,
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 140,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
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
                                    story.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${story.role} at ${story.company}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    story.shortQuote,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
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
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStoryDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
