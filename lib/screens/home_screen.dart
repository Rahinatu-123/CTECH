import 'package:flutter/material.dart';

import '../models/career.dart';
import '../models/story.dart';
import '../services/career_service.dart';
import '../services/stories_service.dart';
import './stories_screen.dart';
import './tech_words_screen.dart';
import './career_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CareerService _careerService = CareerService();
  final StoriesService _storiesService = StoriesService();

  // Define a consistent color scheme
  static const primaryColor = Color(0xFF0A2A36);
  static const accentColor = Color(0xFF2A9D8F);
  static const backgroundColor = Color(0xFFF8F9FA);
  static const cardColor = Colors.white;
  static const textDarkColor = Color(0xFF333333);
  static const textLightColor = Color(0xFF6C757D);

  // Define consistent spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // Define consistent border radius
  static const double borderRadius = 12.0;
  static const double buttonRadius = 30.0;

  // Define consistent shadows
  final BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  List<Career> _careers = [];
  List<Story> _recentStories = [];
  bool _isLoading = true;
  bool _isLoadingStories = true;
  String _error = '';
  String _storiesError = '';
  int _currentIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadCareers();
  //   _loadStories();
  // }
  @override
  void initState() {
    super.initState();
    print("Initializing Home Screen...");
    print("Careers: $_careers");
    print("Stories: $_recentStories");
    _isLoading = false;
    _isLoadingStories = false;

    _careers = [
      Career(
        id: 1,
        title: "Software Engineer",
        description: "Build software",
        salaryRange: "\$80k-\$120k",
        skills: ["Programming", "Problem-solving"],
        education: "Bachelor's in Computer Science",
        jobOutlook: "High demand",
      ),
      Career(
        id: 2,
        title: "Data Scientist",
        description: "Analyze data",
        salaryRange: "\$90k-\$130k",
        skills: ["Data analysis", "Machine learning"],
        education: "Master's in Data Science",
        jobOutlook: "Growing field",
      ),
    ];
    _recentStories = [
      Story(
        id: 101,
        name: "John Doe",
        role: "Engineer",
        company: "TechCorp",
        shortQuote: "I love coding!",
        imagePath: "",
        fullStory:
            "John's journey into tech started with a passion for coding.",
      ),
    ];
    _isLoading = false;
    _isLoadingStories = false;
  }

  Future<void> _loadCareers() async {
    print("Loading careers...");
    try {
      final careers = await _careerService.fetchCareers();
      print("Careers loaded: ${careers.length}");
      if (mounted) {
        setState(() {
          _careers = careers;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading careers: $e");
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadStories() async {
    print("Loading stories...");
    try {
      final stories = await _storiesService.fetchStories();
      print("Stories loaded: ${stories.length}");
      if (mounted) {
        setState(() {
          _recentStories = stories;
          _isLoadingStories = false;
        });
      }
    } catch (e) {
      print("Error loading stories: $e");
      if (mounted) {
        setState(() {
          _storiesError = e.toString();
          _isLoadingStories = false;
        });
      }
    }
  }

  void _navigateToCareerScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CareerScreen()),
    );
  }

  // Reusable loading widget
  Widget _buildLoader() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Reusable error widget
  Widget _buildError(String errorMessage, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(spacing16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 48),
            const SizedBox(height: spacing12),
            const Text(
              'Error loading data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDarkColor,
              ),
            ),
            const SizedBox(height: spacing8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: textLightColor),
            ),
            const SizedBox(height: spacing16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: spacing20,
                  vertical: spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder content when no data is available
  Widget _buildPlaceholder(IconData icon, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(spacing16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: spacing8),
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: textLightColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Reusable section header
  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spacing16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: textDarkColor,
              letterSpacing: 0.3,
            ),
          ),
          TextButton.icon(
            onPressed: onViewAll,
            icon: const Text('View All'),
            label: const Icon(Icons.arrow_forward, size: 16),
            style: TextButton.styleFrom(
              foregroundColor: accentColor,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Banner section widget
  Widget _buildWelcomeBanner() {
    return Container(
      margin: const EdgeInsets.all(spacing16),
      padding: const EdgeInsets.all(spacing20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(spacing8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(spacing8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: spacing12),
              const Expanded(
                child: Text(
                  'Start Your Tech Journey',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: spacing12),
          const Text(
            'Explore careers, learn tech terms, and connect with professionals',
            style: TextStyle(fontSize: 15.0, color: Colors.white, height: 1.4),
          ),
          const SizedBox(height: spacing20),
          ElevatedButton.icon(
            onPressed: _navigateToCareerScreen,
            icon: const Text('Explore Careers'),
            label: const Icon(Icons.arrow_forward, size: 16),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(
                vertical: spacing12,
                horizontal: spacing20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonRadius),
              ),
              elevation: 0,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Career card widget
  Widget _buildCareerCard(Career career) {
    return Container(
      margin: const EdgeInsets.only(bottom: spacing16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [cardShadow],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/career-details', arguments: career);
        },
        borderRadius: BorderRadius.circular(borderRadius),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius),
              ),
              child: Image.network(
                career.imagePath ?? 'https://via.placeholder.com/150',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.work_outline,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      career.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textDarkColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: spacing8),
                    Text(
                      career.description,
                      style: const TextStyle(
                        color: textLightColor,
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: spacing8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacing8,
                        vertical: spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(spacing8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            size: 14,
                            color: primaryColor,
                          ),
                          const SizedBox(width: spacing4),
                          Text(
                            career.salaryRange,
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(spacing16),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Story card widget
  Widget _buildStoryCard(Story story) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: spacing16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [cardShadow],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = 3; // Navigate to Stories tab
          });
        },
        borderRadius: BorderRadius.circular(borderRadius),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius),
              ),
              child: Image.network(
                story.imagePath,
                width: 100,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 180,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.person_outline,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textDarkColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: spacing4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacing8,
                        vertical: spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(spacing8),
                      ),
                      child: Text(
                        '${story.role} at ${story.company}',
                        style: const TextStyle(
                          color: accentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: spacing8),
                    Text(
                      '"${story.shortQuote}"',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        color: textLightColor,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    const Row(
                      children: [
                        Text(
                          'Read more',
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: spacing4),
                        Icon(Icons.arrow_forward, size: 14, color: accentColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the home tab content
  // Widget _buildHomeTab() {
  //   print("Building Home Tab...");
  //   return Container(
  //     color: backgroundColor,
  //     child: RefreshIndicator(
  //       onRefresh: () async {
  //         print("Refreshing Home Tab...");
  //         await Future.wait([_loadCareers(), _loadStories()]);
  //       },
  //       child: ListView(
  //         padding: EdgeInsets.zero,
  //         children: [
  //           _buildWelcomeBanner(),
  //           const SizedBox(height: spacing8),
  //           // Add debug prints for each section
  //           _buildSectionHeader('Featured Careers', _navigateToCareerScreen),
  //           const SizedBox(height: spacing12),
  //           if (_isLoading)
  //             _buildLoader()
  //           else if (_error.isNotEmpty)
  //             _buildError(_error, _loadCareers)
  //           else if (_careers.isEmpty)
  //             _buildPlaceholder(Icons.work_off, 'No careers found')
  //           else
  //             ..._careers.take(3).map((career) => _buildCareerCard(career)),
  //           const SizedBox(height: spacing24),
  //           _buildSectionHeader(
  //             'Success Stories',
  //             () => setState(() => _currentIndex = 3),
  //           ),
  //           const SizedBox(height: spacing12),
  //           if (_isLoadingStories)
  //             _buildLoader()
  //           else if (_storiesError.isNotEmpty)
  //             _buildError(_storiesError, _loadStories)
  //           else if (_recentStories.isEmpty)
  //             _buildPlaceholder(
  //               Icons.speaker_notes_off,
  //               'No stories available yet',
  //             )
  //           else
  //             ..._recentStories.take(3).map((story) => _buildStoryCard(story)),
  //           const SizedBox(height: spacing32),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // Widget _buildHomeTab() {
  //   return Container(
  //     color: backgroundColor,
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [_buildWelcomeBanner()],
  //     ),
  //   );
  // }
  // Widget _buildHomeTab() {
  //   return _buildWelcomeBanner();
  // }
  Widget _buildHomeTab() {
    return _buildWelcomeBanner();
  }
  // Widget _buildHomeTab() {
  //   return Container(
  //     color: backgroundColor,
  //     child: RefreshIndicator(
  //       onRefresh: () async {
  //         await Future.wait([_loadCareers(), _loadStories()]);
  //       },
  //       child: ListView(
  //         padding: EdgeInsets.zero, // Important to fix potential layout issues
  //         children: [
  //           _buildWelcomeBanner(),

  //           const SizedBox(height: spacing8),

  //           // Featured Careers Section
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _buildSectionHeader(
  //                 'Featured Careers',
  //                 _navigateToCareerScreen,
  //               ),

  //               const SizedBox(height: spacing12),

  //               // Use SizedBox with specific height to avoid layout issues
  //               SizedBox(
  //                 // height: _isLoading ? 200 : null,
  //                 height: _isLoading ? null : null, // Remove fixed height
  //                 child:
  //                     _isLoading
  //                         ? _buildLoader()
  //                         : _error.isNotEmpty
  //                         ? _buildError(_error, _loadCareers)
  //                         : _careers.isEmpty
  //                         ? _buildPlaceholder(
  //                           Icons.work_off,
  //                           'No careers found',
  //                         )
  //                         : Padding(
  //                           padding: const EdgeInsets.symmetric(
  //                             horizontal: spacing16,
  //                           ),
  //                           child: Column(
  //                             children:
  //                                 _careers
  //                                     .take(3)
  //                                     .map((career) => _buildCareerCard(career))
  //                                     .toList(),
  //                           ),
  //                         ),
  //               ),
  //             ],
  //           ),

  //           const SizedBox(height: spacing24),

  //           // Success Stories Section
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _buildSectionHeader(
  //                 'Success Stories',
  //                 () => setState(() => _currentIndex = 3),
  //               ),

  //               const SizedBox(height: spacing12),

  //               // Use SizedBox with specific height for story section
  //               SizedBox(
  //                 height: 200,
  //                 child:
  //                     _isLoadingStories
  //                         ? _buildLoader()
  //                         : _storiesError.isNotEmpty
  //                         ? _buildError(_storiesError, _loadStories)
  //                         : _recentStories.isEmpty
  //                         ? _buildPlaceholder(
  //                           Icons.speaker_notes_off,
  //                           'No stories available yet',
  //                         )
  //                         : ListView.builder(
  //                           scrollDirection: Axis.horizontal,
  //                           itemCount:
  //                               _recentStories.length > 3
  //                                   ? 3
  //                                   : _recentStories.length,
  //                           padding: const EdgeInsets.symmetric(
  //                             horizontal: spacing16,
  //                           ),
  //                           itemBuilder: (context, index) {
  //                             return _buildStoryCard(_recentStories[index]);
  //                           },
  //                         ),
  //               ),
  //             ],
  //           ),

  //           const SizedBox(height: spacing32),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Build the careers tab content
  Widget _buildCareersTab() {
    return _buildWelcomeBanner();
    // FIND A WAY TO CALL BUILD CAREER CARD WITHIN THIS BUILD CAREER TAB

    // return Center(
    //   child: Text(
    //     "Career Tab Content",
    //     style: TextStyle(fontSize: 24, color: Colors.black),
    //   ),
    // );
  }
  // Widget _buildCareersTab() {
  //   return Container(
  //     color: backgroundColor,
  //     child: RefreshIndicator(
  //       onRefresh: _loadCareers,
  //       child: ListView(
  //         padding: EdgeInsets.zero, // Important to fix layout issues
  //         children: [
  //           // Search Bar
  //           Padding(
  //             padding: const EdgeInsets.all(spacing16),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: cardColor,
  //                 borderRadius: BorderRadius.circular(borderRadius),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withOpacity(0.05),
  //                     blurRadius: 6,
  //                     offset: const Offset(0, 2),
  //                   ),
  //                 ],
  //               ),
  //               child: TextField(
  //                 decoration: InputDecoration(
  //                   hintText: 'Search careers...',
  //                   hintStyle: TextStyle(color: Colors.grey[400]),
  //                   prefixIcon: const Icon(Icons.search, color: textLightColor),
  //                   suffixIcon: const Icon(Icons.mic, color: primaryColor),
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(borderRadius),
  //                     borderSide: BorderSide.none,
  //                   ),
  //                   contentPadding: const EdgeInsets.symmetric(
  //                     vertical: spacing12,
  //                   ),
  //                   filled: true,
  //                   fillColor: cardColor,
  //                 ),
  //                 onChanged: (value) {
  //                   // Search functionality would go here
  //                 },
  //               ),
  //             ),
  //           ),

  //           const Padding(
  //             padding: EdgeInsets.symmetric(horizontal: spacing16),
  //             child: Text(
  //               'All Careers',
  //               style: TextStyle(
  //                 fontSize: 22.0,
  //                 fontWeight: FontWeight.bold,
  //                 color: textDarkColor,
  //                 letterSpacing: 0.3,
  //               ),
  //             ),
  //           ),

  //           const SizedBox(height: spacing8),

  //           // Use Container with height to ensure visibility when loading/error
  //           SizedBox(
  //             height:
  //                 _isLoading || _error.isNotEmpty || _careers.isEmpty
  //                     ? 400
  //                     : null,
  //             child:
  //                 _isLoading
  //                     ? _buildLoader()
  //                     : _error.isNotEmpty
  //                     ? _buildError(_error, _loadCareers)
  //                     : _careers.isEmpty
  //                     ? _buildPlaceholder(Icons.work_off, 'No careers found')
  //                     : Padding(
  //                       padding: const EdgeInsets.all(spacing16),
  //                       child: GridView.builder(
  //                         shrinkWrap: true,
  //                         physics: const NeverScrollableScrollPhysics(),
  //                         gridDelegate:
  //                             const SliverGridDelegateWithFixedCrossAxisCount(
  //                               crossAxisCount: 2,
  //                               crossAxisSpacing: 16.0,
  //                               mainAxisSpacing: 16.0,
  //                               childAspectRatio: 0.75,
  //                             ),
  //                         itemCount: _careers.length,
  //                         itemBuilder: (context, index) {
  //                           final career = _careers[index];
  //                           return Container(
  //                             decoration: BoxDecoration(
  //                               color: cardColor,
  //                               borderRadius: BorderRadius.circular(
  //                                 borderRadius,
  //                               ),
  //                               boxShadow: [cardShadow],
  //                             ),
  //                             child: InkWell(
  //                               onTap: () {
  //                                 Navigator.pushNamed(
  //                                   context,
  //                                   '/career-details',
  //                                   arguments: career,
  //                                 );
  //                               },
  //                               borderRadius: BorderRadius.circular(
  //                                 borderRadius,
  //                               ),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   ClipRRect(
  //                                     borderRadius: const BorderRadius.only(
  //                                       topLeft: Radius.circular(borderRadius),
  //                                       topRight: Radius.circular(borderRadius),
  //                                     ),
  //                                     child: Image.network(
  //                                       career.imagePath ??
  //                                           'https://via.placeholder.com/150',
  //                                       height: 120,
  //                                       width: double.infinity,
  //                                       fit: BoxFit.cover,
  //                                       errorBuilder: (
  //                                         context,
  //                                         error,
  //                                         stackTrace,
  //                                       ) {
  //                                         return Container(
  //                                           height: 120,
  //                                           color: Colors.grey[200],
  //                                           child: const Icon(
  //                                             Icons.work_outline,
  //                                             size: 40,
  //                                             color: Colors.grey,
  //                                           ),
  //                                         );
  //                                       },
  //                                     ),
  //                                   ),
  //                                   Padding(
  //                                     padding: const EdgeInsets.all(spacing12),
  //                                     child: Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                           career.title,
  //                                           style: const TextStyle(
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 16,
  //                                             color: textDarkColor,
  //                                           ),
  //                                           maxLines: 1,
  //                                           overflow: TextOverflow.ellipsis,
  //                                         ),
  //                                         const SizedBox(height: spacing4),
  //                                         Text(
  //                                           career.description,
  //                                           style: const TextStyle(
  //                                             color: textLightColor,
  //                                             fontSize: 12,
  //                                             height: 1.4,
  //                                           ),
  //                                           maxLines: 2,
  //                                           overflow: TextOverflow.ellipsis,
  //                                         ),
  //                                         const SizedBox(height: spacing8),
  //                                         Container(
  //                                           padding: const EdgeInsets.symmetric(
  //                                             horizontal: spacing8,
  //                                             vertical: spacing4,
  //                                           ),
  //                                           decoration: BoxDecoration(
  //                                             color: primaryColor.withOpacity(
  //                                               0.1,
  //                                             ),
  //                                             borderRadius:
  //                                                 BorderRadius.circular(
  //                                                   spacing8,
  //                                                 ),
  //                                           ),
  //                                           child: Text(
  //                                             career.salaryRange,
  //                                             style: const TextStyle(
  //                                               color: primaryColor,
  //                                               fontWeight: FontWeight.bold,
  //                                               fontSize: 11,
  //                                             ),
  //                                             maxLines: 1,
  //                                             overflow: TextOverflow.ellipsis,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.code_rounded, color: Colors.white, size: 24),
            SizedBox(width: spacing8),
            Text(
              'CTech',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/quiz');
            },
            tooltip: 'Take Quiz',
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
          _buildCareersTab(),
          const TechWordsScreen(),
          const StoriesScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            print("Navigating to tab index: $index");
            setState(() => _currentIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: cardColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: textLightColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          elevation: 0,
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
      ),
    );
  }
}
