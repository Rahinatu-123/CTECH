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
  final _searchController = TextEditingController();
  String _searchQuery = '';

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
    _searchController.dispose();
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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tech Words',
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(screenSize.width * 0.02),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tech words...',
                prefixIcon: Icon(
                  Icons.search,
                  size: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.015,
                  horizontal: screenSize.width * 0.02,
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
              ),
              onChanged: (value) {
                // Search functionality would go here
              },
            ),
          ),

          // Categories
          SizedBox(
            height: screenSize.height * 0.06,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
              children: [
                _buildCategoryChip(
                  context,
                  'All',
                  true,
                  screenSize,
                  isSmallScreen,
                ),
                _buildCategoryChip(
                  context,
                  'Programming',
                  false,
                  screenSize,
                  isSmallScreen,
                ),
                _buildCategoryChip(
                  context,
                  'Web Development',
                  false,
                  screenSize,
                  isSmallScreen,
                ),
                _buildCategoryChip(
                  context,
                  'Mobile Development',
                  false,
                  screenSize,
                  isSmallScreen,
                ),
                _buildCategoryChip(
                  context,
                  'Data Science',
                  false,
                  screenSize,
                  isSmallScreen,
                ),
                _buildCategoryChip(
                  context,
                  'DevOps',
                  false,
                  screenSize,
                  isSmallScreen,
                ),
              ],
            ),
          ),

          // Word List
          Expanded(
            child: FutureBuilder<List<TechWord>>(
              future: _futureTechWords,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final techWords = snapshot.data ?? [];
                final filteredWords = techWords.where((word) => word.word.toLowerCase().contains(_searchQuery)).toList();

                if (filteredWords.isEmpty) {
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

                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(screenSize.width * 0.02),
                    itemCount: filteredWords.length,
                    itemBuilder: (context, index) {
                      final word = filteredWords[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: screenSize.height * 0.01),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenSize.width * 0.01),
                        ),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            child: Text(
                              word.word[0].toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            word.word,
                            style: TextStyle(
                              fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            word.category.isEmpty ? 'General' : word.category,
                            style: TextStyle(
                              fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(screenSize.width * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meaning:',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? screenSize.width * 0.03 : screenSize.width * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: screenSize.height * 0.005),
                                  Text(
                                    word.meaning,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                                    ),
                                  ),
                                  if (word.example != null) ...[
                                    SizedBox(height: screenSize.height * 0.01),
                                    Text(
                                      'Example:',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? screenSize.width * 0.03 : screenSize.width * 0.02,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: screenSize.height * 0.005),
                                    Container(
                                      padding: EdgeInsets.all(screenSize.width * 0.02),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(screenSize.width * 0.01),
                                      ),
                                      child: Text(
                                        word.example!,
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWordDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    bool isSelected,
    Size screenSize,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: screenSize.width * 0.02),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          // Handle category selection
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Theme.of(context).primaryColor,
        checkmarkColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.02,
          vertical: screenSize.height * 0.005,
        ),
      ),
    );
  }
}
