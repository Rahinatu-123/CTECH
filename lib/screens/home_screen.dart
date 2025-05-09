import 'package:flutter/material.dart';
import '../models/career.dart';
import '../models/story.dart';
import '../services/career_service.dart';
import '../services/stories_service.dart';
import './stories_screen.dart';
import './tech_words_screen.dart';
import './career_screen.dart';
import './profile_screen.dart';
import './quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CareerService _careerService = CareerService();
  final StoriesService _storiesService = StoriesService();
  static const darkBlue = Color(0xFF0A2A36);
  
  List<Career> _careers = [];
  List<Story> _recentStories = [];
  bool _isLoading = true;
  bool _isLoadingStories = true;
  String _error = '';
  String _storiesError = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCareers();
    _loadStories();
  }

  Future<void> _loadCareers() async {
    try {
      final careers = await _careerService.fetchCareers();
      if (mounted) {
        setState(() {
          _careers = careers;
          _isLoading = false;
          _error = '';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading careers: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadStories() async {
    try {
      final stories = await _storiesService.fetchStories();
      if (mounted) {
        setState(() {
          _recentStories = stories;
          _isLoadingStories = false;
          _storiesError = '';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _storiesError = e.toString();
          _isLoadingStories = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading stories: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

  Widget _buildHomeTab() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        // Welcome Banner
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.waving_hand,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore tech careers and find your path',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Explore Careers',
                          style: TextStyle(
                            color: darkBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward, color: darkBlue, size: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Featured Careers Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Careers',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_error.isNotEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: $_error',
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: _loadCareers,
                  child: const Text(
                    'Retry',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          )
        else if (_careers.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'No careers found.',
                style: TextStyle(fontSize: 10),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _careers.length > 3 ? 3 : _careers.length,
            itemBuilder: (context, index) {
              final career = _careers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/career-details',
                    arguments: career,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Icon(
                              _getCareerIcon(career.title),
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                career.title,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                career.description,
                                style: TextStyle(
                                  fontSize: 9,
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
                ),
              );
            },
          ),

        const SizedBox(height: 16),

        // Success Stories Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Success Stories',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoadingStories)
          const Center(child: CircularProgressIndicator())
        else if (_storiesError.isNotEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: $_storiesError',
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: _loadStories,
                  child: const Text(
                    'Retry',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          )
        else if (_recentStories.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'No stories available yet.',
                style: TextStyle(fontSize: 10),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentStories.length > 3 ? 3 : _recentStories.length,
            itemBuilder: (context, index) {
              final story = _recentStories[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/story-details',
                    arguments: story,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            story.imagePath ?? 'https://via.placeholder.com/40',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 40,
                                height: 40,
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story.name,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${story.role} at ${story.company}',
                                style: TextStyle(
                                  fontSize: 9,
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
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CTECH'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon!'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            tooltip: 'Profile',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          const CareerScreen(),
          const TechWordsScreen(),
          const StoriesScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: darkBlue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Careers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Tech Words',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Stories',
          ),
        ],
      ),
    );
  }
}