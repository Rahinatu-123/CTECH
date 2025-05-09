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
                  maxLines: 5,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the full story' : null,
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
          ElevatedButton(
            onPressed: _isSubmitting
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isSubmitting = true);
                      try {
                        final story = Story(
                          id: 0,
                          name: _nameController.text,
                          role: _roleController.text,
                          company: _companyController.text,
                          imagePath: _imagePathController.text,
                          shortQuote: _shortQuoteController.text,
                          fullStory: _fullStoryController.text,
                        );
                        await _storiesService.addStory(story);
                        if (mounted) {
                          Navigator.pop(context);
                          setState(() {
                            _futureStories = _storiesService.fetchStories();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Story added successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error adding story: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() => _isSubmitting = false);
                        }
                      }
                    }
                  },
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add Story'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Success Stories',
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddStoryDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(screenSize.width * 0.04),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search stories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.04,
                  vertical: screenSize.height * 0.015,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Story>>(
              future: _futureStories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _futureStories = _storiesService.fetchStories();
                            });
                          },
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No stories available',
                      style: TextStyle(
                        fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                      ),
                    ),
                  );
                }

                final stories = snapshot.data!;
                final filteredStories = stories.where((story) {
                  final searchLower = _searchQuery.toLowerCase();
                  return story.name.toLowerCase().contains(searchLower) ||
                      story.role.toLowerCase().contains(searchLower) ||
                      story.company.toLowerCase().contains(searchLower);
                }).toList();

                if (filteredStories.isEmpty) {
                  return Center(
                    child: Text(
                      'No matching stories found',
                      style: TextStyle(
                        fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(screenSize.width * 0.02),
                  itemCount: filteredStories.length,
                  itemBuilder: (context, index) {
                    final story = filteredStories[index];
                    return Card(
                      margin: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.01,
                        horizontal: screenSize.width * 0.02,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/story-details',
                          arguments: story,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.width * 0.02),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                                child: Image.network(
                                  story.imagePath ?? 'https://via.placeholder.com/40',
                                  width: screenSize.width * 0.1,
                                  height: screenSize.width * 0.1,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: screenSize.width * 0.1,
                                      height: screenSize.width * 0.1,
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.person,
                                        size: screenSize.width * 0.05,
                                        color: Colors.grey[400],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: screenSize.width * 0.02),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      story.name,
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: screenSize.height * 0.005),
                                    Text(
                                      '${story.role} at ${story.company}',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
