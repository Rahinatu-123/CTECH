// import 'package:flutter/material.dart';
// import '../models/career.dart';
// import '../models/story.dart';
// import '../services/career_service.dart';
// import '../services/stories_service.dart';
// import './stories_screen.dart';
// import './tech_words_screen.dart';
// import './career_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final CareerService _careerService = CareerService();
//   final StoriesService _storiesService = StoriesService();
  
//   // Define a consistent color scheme
//   static const primaryColor = Color(0xFF0A2A36);
//   static const accentColor = Color(0xFF2A9D8F);
//   static const backgroundColor = Color(0xFFF8F9FA);
//   static const cardColor = Colors.white;
//   static const textDarkColor = Color(0xFF333333);
//   static const textLightColor = Color(0xFF6C757D);
  
//   // Define consistent spacing
//   static const double spacing4 = 4.0;
//   static const double spacing8 = 8.0;
//   static const double spacing12 = 12.0;
//   static const double spacing16 = 16.0;
//   static const double spacing20 = 20.0;
//   static const double spacing24 = 24.0;
//   static const double spacing32 = 32.0;
  
//   // Define consistent border radius
//   static const double borderRadius = 12.0;
//   static const double buttonRadius = 30.0;
  
//   // Define consistent shadows
//   final BoxShadow cardShadow = BoxShadow(
//     color: Colors.black.withOpacity(0.08),
//     blurRadius: 10,
//     offset: const Offset(0, 4),
//   );
  
//   List<Career> _careers = [];
//   List<Story> _recentStories = [];
//   bool _isLoading = true;
//   bool _isLoadingStories = true;
//   String _error = '';
//   String _storiesError = '';
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadCareers();
//     _loadStories();
//   }

//   Future<void> _loadCareers() async {
//     try {
//       final careers = await _careerService.fetchCareers();
//       if (mounted) {
//         setState(() {
//           _careers = careers;
//           _isLoading = false;
//           _error = '';
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _error = e.toString();
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _loadStories() async {
//     try {
//       final stories = await _storiesService.fetchStories();
//       if (mounted) {
//         setState(() {
//           _recentStories = stories;
//           _isLoadingStories = false;
//           _storiesError = '';
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _storiesError = e.toString();
//           _isLoadingStories = false;
//         });
//       }
//     }
//   }

//   void _navigateToCareerScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const CareerScreen()),
//     );
//   }

//   // Reusable loading widget
//   Widget _buildLoader() {
//     return const Center(
//       child: SizedBox(
//         width: 40,
//         height: 40,
//         child: CircularProgressIndicator(
//           strokeWidth: 3,
//         ),
//       ),
//     );
//   }

//   // Reusable error widget
//   Widget _buildError(String errorMessage, VoidCallback onRetry) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(spacing16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               color: Colors.red[400],
//               size: 48,
//             ),
//             SizedBox(height: spacing12),
//             Text(
//               'Error loading data',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: textDarkColor,
//               ),
//             ),
//             SizedBox(height: spacing8),
//             Text(
//               errorMessage,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: textLightColor,
//               ),
//             ),
//             SizedBox(height: spacing16),
//             ElevatedButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Retry'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: accentColor,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: spacing20, vertical: spacing12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(buttonRadius),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Reusable section header
//   Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: spacing16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20.0,
//               fontWeight: FontWeight.bold,
//               color: textDarkColor,
//               letterSpacing: 0.3,
//             ),
//           ),
//           TextButton.icon(
//             onPressed: onViewAll,
//             icon: const Text('View All'),
//             label: const Icon(Icons.arrow_forward, size: 16),
//             style: TextButton.styleFrom(
//               foregroundColor: accentColor,
//               textStyle: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Banner section widget
//   Widget _buildWelcomeBanner() {
//     return Container(
//       margin: EdgeInsets.all(spacing16),
//       padding: EdgeInsets.all(spacing20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [primaryColor, primaryColor.withOpacity(0.8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(borderRadius),
//         boxShadow: [cardShadow],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(spacing8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(spacing8),
//                 ),
//                 child: const Icon(
//                   Icons.lightbulb_outline,
//                   color: Colors.white,
//                   size: 24,
//                 ),
//               ),
//               SizedBox(width: spacing12),
//               const Expanded(
//                 child: Text(
//                   'Start Your Tech Journey',
//                   style: TextStyle(
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: spacing12),
//           const Text(
//             'Explore careers, learn tech terms, and connect with professionals',
//             style: TextStyle(
//               fontSize: 15.0,
//               color: Colors.white,
//               height: 1.4,
//             ),
//           ),
//           SizedBox(height: spacing20),
//           ElevatedButton.icon(
//             onPressed: _navigateToCareerScreen,
//             icon: const Text('Explore Careers'),
//             label: const Icon(Icons.arrow_forward, size: 16),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: primaryColor,
//               padding: EdgeInsets.symmetric(vertical: spacing12, horizontal: spacing20),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(buttonRadius),
//               ),
//               elevation: 0,
//               textStyle: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Career card widget
//   Widget _buildCareerCard(Career career) {
//     return Container(
//       margin: EdgeInsets.only(bottom: spacing16),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(borderRadius),
//         boxShadow: [cardShadow],
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.pushNamed(
//             context,
//             '/career-details',
//             arguments: career,
//           );
//         },
//         borderRadius: BorderRadius.circular(borderRadius),
//         child: Row(
//           children: [
//             Hero(
//               tag: 'career-image-${career.id}',
//               child: ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(borderRadius),
//                   bottomLeft: Radius.circular(borderRadius),
//                 ),
//                 child: Image.network(
//                   career.imagePath ?? 'https://via.placeholder.com/150',
//                   width: 120,
//                   height: 120,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       width: 120,
//                       height: 120,
//                       color: Colors.grey[200],
//                       child: const Icon(
//                         Icons.work_outline,
//                         size: 40,
//                         color: Colors.grey,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.all(spacing16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       career.title,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: textDarkColor,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: spacing8),
//                     Text(
//                       career.description,
//                       style: const TextStyle(
//                         color: textLightColor,
//                         fontSize: 14,
//                         height: 1.3,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: spacing8),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: spacing8, vertical: spacing4),
//                       decoration: BoxDecoration(
//                         color: primaryColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(spacing8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.trending_up,
//                             size: 14,
//                             color: primaryColor,
//                           ),
//                           SizedBox(width: spacing4),
//                           Text(
//                             career.salaryRange,
//                             style: TextStyle(
//                               color: primaryColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(spacing16),
//               child: Icon(
//                 Icons.arrow_forward_ios,
//                 size: 16,
//                 color: Colors.grey[400],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Story card widget
//   Widget _buildStoryCard(Story story) {
//     return Container(
//       width: 280,
//       margin: EdgeInsets.only(right: spacing16),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(borderRadius),
//         boxShadow: [cardShadow],
//       ),
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             _currentIndex = 3; // Navigate to Stories tab
//           });
//         },
//         borderRadius: BorderRadius.circular(borderRadius),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(borderRadius),
//                 bottomLeft: Radius.circular(borderRadius),
//               ),
//               child: Image.network(
//                 story.imagePath,
//                 width: 100,
//                 height: 180,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     width: 100,
//                     height: 180,
//                     color: Colors.grey[200],
//                     child: const Icon(
//                       Icons.person_outline,
//                       size: 40,
//                       color: Colors.grey,
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.all(spacing12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       story.name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: textDarkColor,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: spacing4),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: spacing8, vertical: spacing4),
//                       decoration: BoxDecoration(
//                         color: accentColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(spacing8),
//                       ),
//                       child: Text(
//                         '${story.role} at ${story.company}',
//                         style: TextStyle(
//                           color: accentColor,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(height: spacing8),
//                     Text(
//                       '"${story.shortQuote}"',
//                       style: const TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontSize: 13,
//                         color: textLightColor,
//                         height: 1.4,
//                       ),
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const Spacer(),
//                     Row(
//                       children: [
//                         Text(
//                           'Read more',
//                           style: TextStyle(
//                             color: accentColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                         SizedBox(width: spacing4),
//                         Icon(
//                           Icons.arrow_forward,
//                           size: 14,
//                           color: accentColor,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Build the home tab content
//   Widget _buildHomeTab() {
//     return Container(
//       color: backgroundColor,
//       child: ListView(
//         children: [
//           _buildWelcomeBanner(),
          
//           SizedBox(height: spacing8),

//           // Featured Careers Section
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionHeader(
//                 'Featured Careers',
//                 _navigateToCareerScreen,
//               ),
                            
//               SizedBox(height: spacing12),
              
//               if (_isLoading)
//                 _buildLoader()
//               else if (_error.isNotEmpty)
//                 _buildError(_error, _loadCareers)
//               else if (_careers.isEmpty)
//                 Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(spacing16),
//                     child: Column(
//                       children: [
//                         const Icon(
//                           Icons.work_off,
//                           size: 48,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(height: spacing8),
//                         const Text(
//                           'No careers found',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: textLightColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               else
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: spacing16),
//                   child: Column(
//                     children: _careers
//                         .take(3)
//                         .map((career) => _buildCareerCard(career))
//                         .toList(),
//                   ),
//                 ),
//             ],
//           ),
          
//           SizedBox(height: spacing24),
          
//           // Success Stories Section
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionHeader(
//                 'Success Stories',
//                 () => setState(() => _currentIndex = 3),
//               ),
              
//               SizedBox(height: spacing12),
              
//               if (_isLoadingStories)
//                 _buildLoader()
//               else if (_storiesError.isNotEmpty)
//                 _buildError(_storiesError, _loadStories)
//               else if (_recentStories.isEmpty)
//                 Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(spacing16),
//                     child: Column(
//                       children: [
//                         const Icon(
//                           Icons.speaker_notes_off,
//                           size: 48,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(height: spacing8),
//                         const Text(
//                           'No stories available yet',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: textLightColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               else
//                 SizedBox(
//                   height: 180,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _recentStories.length > 3 ? 3 : _recentStories.length,
//                     padding: EdgeInsets.symmetric(horizontal: spacing16),
//                     itemBuilder: (context, index) {
//                       return _buildStoryCard(_recentStories[index]);
//                     },
//                   ),
//                 ),
//             ],
//           ),
          
//           SizedBox(height: spacing32),
//         ],
//       ),
//     );
//   }

//   // Build the careers tab content
//   Widget _buildCareersTab() {
//     return Container(
//       color: backgroundColor,
//       child: ListView(
//         children: [
//           // Search Bar
//           Padding(
//             padding: EdgeInsets.all(spacing16),
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
//                   suffixIcon: Icon(Icons.mic, color: primaryColor),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(borderRadius),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding: EdgeInsets.symmetric(vertical: spacing12),
//                   filled: true,
//                   fillColor: cardColor,
//                 ),
//                 onChanged: (value) {
//                   // Search functionality would go here
//                 },
//               ),
//             ),
//           ),

//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: spacing16),
//             child: const Text(
//               'All Careers',
//               style: TextStyle(
//                 fontSize: 22.0,
//                 fontWeight: FontWeight.bold,
//                 color: textDarkColor,
//                 letterSpacing: 0.3,
//               ),
//             ),
//           ),
          
//           SizedBox(height: spacing8),
          
//           if (_isLoading)
//             _buildLoader()
//           else if (_error.isNotEmpty)
//             _buildError(_error, _loadCareers)
//           else if (_careers.isEmpty)
//             Center(
//               child: Padding(
//                 padding: EdgeInsets.all(spacing16),
//                 child: Column(
//                   children: [
//                     const Icon(
//                       Icons.work_off,
//                       size: 64,
//                       color: Colors.grey,
//                     ),
//                     SizedBox(height: spacing12),
//                     const Text(
//                       'No careers found',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: textDarkColor,
//                       ),
//                     ),
//                     SizedBox(height: spacing8),
//                     const Text(
//                       'We couldn\'t find any careers at the moment.',
//                       style: TextStyle(
//                         color: textLightColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           else
//             Padding(
//               padding: EdgeInsets.all(spacing16),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16.0,
//                   mainAxisSpacing: 16.0,
//                   childAspectRatio: 0.75,
//                 ),
//                 itemCount: _careers.length,
//                 itemBuilder: (context, index) {
//                   final career = _careers[index];
//                   return Container(
//                     decoration: BoxDecoration(
//                       color: cardColor,
//                       borderRadius: BorderRadius.circular(borderRadius),
//                       boxShadow: [cardShadow],
//                     ),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.pushNamed(
//                           context,
//                           '/career-details',
//                           arguments: career,
//                         );
//                       },
//                       borderRadius: BorderRadius.circular(borderRadius),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Hero(
//                             tag: 'career-grid-${career.id}',
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(borderRadius),
//                                 topRight: Radius.circular(borderRadius),
//                               ),
//                               child: Image.network(
//                                 career.imagePath ?? 'https://via.placeholder.com/150',
//                                 height: 120,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Container(
//                                     height: 120,
//                                     color: Colors.grey[200],
//                                     child: const Icon(
//                                       Icons.work_outline,
//                                       size: 40,
//                                       color: Colors.grey,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(spacing12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   career.title,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                     color: textDarkColor,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: spacing4),
//                                 Text(
//                                   career.description,
//                                   style: const TextStyle(
//                                     color: textLightColor,
//                                     fontSize: 12,
//                                     height: 1.4,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: spacing8),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: spacing8,
//                                     vertical: spacing4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: primaryColor.withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(spacing8),
//                                   ),
//                                   child: Text(
//                                     career.salaryRange,
//                                     style: TextStyle(
//                                       color: primaryColor,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 11,
//                                     ),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Icon(
//               Icons.code_rounded,
//               color: Colors.white,
//               size: 24,
//             ),
//             SizedBox(width: spacing8),
//             const Text(
//               'CTech',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontSize: 20,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: primaryColor,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.quiz_outlined),
//             onPressed: () {
//               Navigator.pushNamed(context, '/quiz');
//             },
//             tooltip: 'Take Quiz',
//           ),
//           IconButton(
//             icon: const Icon(Icons.person_outline),
//             onPressed: () => Navigator.pushNamed(context, '/profile'),
//             tooltip: 'Profile',
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings_outlined),
//             onPressed: () => Navigator.pushNamed(context, '/settings'),
//             tooltip: 'Settings',
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: _currentIndex,
//         children: [
//           _buildHomeTab(),
//           _buildCareersTab(),
//           const TechWordsScreen(),
//           const StoriesScreen(),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 0,
//               offset: const Offset(0, -1),
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (index) => setState(() => _currentIndex = index),
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: cardColor,
//           selectedItemColor: primaryColor,
//           unselectedItemColor: textLightColor,
//           selectedLabelStyle: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//           ),
//           unselectedLabelStyle: const TextStyle(fontSize: 11),
//           elevation: 0,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home_outlined),
//               activeIcon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.work_outline),
//               activeIcon: Icon(Icons.work),
//               label: 'Careers',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.book_outlined),
//               activeIcon: Icon(Icons.book),
//               label: 'Tech Words',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.article_outlined),
//               activeIcon: Icon(Icons.article),
//               label: 'Stories',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import '../models/career.dart';
// // import '../models/story.dart';
// // import '../services/career_service.dart';
// // import '../services/stories_service.dart';
// // import './stories_screen.dart';
// // import './tech_words_screen.dart';
// // import './career_screen.dart'; // Import the CareerScreen

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({Key? key}) : super(key: key);

// //   @override
// //   _HomeScreenState createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   final CareerService _careerService = CareerService();
// //   final StoriesService _storiesService = StoriesService();
// //   static const darkBlue = Color(0xFF0A2A36);
  
// //   List<Career> _careers = [];
// //   List<Story> _recentStories = [];
// //   bool _isLoading = true;
// //   bool _isLoadingStories = true;
// //   String _error = '';
// //   String _storiesError = '';
// //   int _currentIndex = 0;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadCareers();
// //     _loadStories();
// //   }

// //   Future<void> _loadCareers() async {
// //     try {
// //       final careers = await _careerService.fetchCareers();
// //       if (mounted) {
// //         setState(() {
// //           _careers = careers;
// //           _isLoading = false;
// //           _error = '';
// //         });
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         setState(() {
// //           _error = e.toString();
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   Future<void> _loadStories() async {
// //     try {
// //       final stories = await _storiesService.fetchStories();
// //       if (mounted) {
// //         setState(() {
// //           _recentStories = stories;
// //           _isLoadingStories = false;
// //           _storiesError = '';
// //         });
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         setState(() {
// //           _storiesError = e.toString();
// //           _isLoadingStories = false;
// //         });
// //       }
// //     }
// //   }

// //   // Navigate to the CareerScreen
// //   void _navigateToCareerScreen() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => const CareerScreen()),
// //     );
// //   }

// //   Widget _buildHomeTab() {
// //     return ListView(
// //       children: [
// //         // Welcome Banner
// //         Container(
// //           margin: const EdgeInsets.all(16.0),
// //           padding: const EdgeInsets.all(20.0),
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [darkBlue, darkBlue.withOpacity(0.7)],
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //             ),
// //             borderRadius: BorderRadius.circular(16.0),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.1),
// //                 blurRadius: 10,
// //                 offset: const Offset(0, 4),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 'Start Your Tech Journey',
// //                 style: TextStyle(
// //                   fontSize: 24.0,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //               const SizedBox(height: 8.0),
// //               const Text(
// //                 'Explore careers, learn tech terms, and connect with professionals',
// //                 style: TextStyle(
// //                   fontSize: 14.0,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //               const SizedBox(height: 20.0),
// //               InkWell(
// //                 onTap: _navigateToCareerScreen, // Changed to navigate to CareerScreen
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(30.0),
// //                   ),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Text(
// //                         'Explore Careers',
// //                         style: TextStyle(
// //                           color: darkBlue,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8.0),
// //                       Icon(Icons.arrow_forward, color: darkBlue, size: 16),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),

// //         // Featured Careers Section - Just a few careers
// //         Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   const Text(
// //                     'Featured Careers',
// //                     style: TextStyle(
// //                       fontSize: 20.0,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   TextButton(
// //                     onPressed: _navigateToCareerScreen, // Changed to navigate to CareerScreen
// //                     child: const Text('View All'),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 12.0),
// //               if (_isLoading)
// //                 const Center(child: CircularProgressIndicator())
// //               else if (_error.isNotEmpty)
// //                 Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text('Error: $_error'),
// //                       const SizedBox(height: 8.0),
// //                       ElevatedButton(
// //                         onPressed: _loadCareers,
// //                         child: const Text('Retry'),
// //                       ),
// //                     ],
// //                   ),
// //                 )
// //               else if (_careers.isEmpty)
// //                 const Center(
// //                   child: Padding(
// //                     padding: EdgeInsets.all(16.0),
// //                     child: Text('No careers found.'),
// //                   ),
// //                 )
// //               else
// //                 ListView.builder(
// //                   shrinkWrap: true,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   itemCount: _careers.length > 3 ? 3 : _careers.length,
// //                   itemBuilder: (context, index) {
// //                     final career = _careers[index];
// //                     return Container(
// //                       margin: const EdgeInsets.only(bottom: 16),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(12),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.05),
// //                             blurRadius: 8,
// //                             offset: const Offset(0, 2),
// //                           ),
// //                         ],
// //                       ),
// //                       child: InkWell(
// //                         onTap: () {
// //                           Navigator.pushNamed(
// //                             context,
// //                             '/career-details',
// //                             arguments: career,
// //                           );
// //                         },
// //                         child: Row(
// //                           children: [
// //                             ClipRRect(
// //                               borderRadius: const BorderRadius.only(
// //                                 topLeft: Radius.circular(12),
// //                                 bottomLeft: Radius.circular(12),
// //                               ),
// //                               child: Image.network(
// //                                 career.imagePath ?? 'https://via.placeholder.com/150',
// //                                 width: 120,
// //                                 height: 120,
// //                                 fit: BoxFit.cover,
// //                                 errorBuilder: (context, error, stackTrace) {
// //                                   return Container(
// //                                     width: 120,
// //                                     height: 120,
// //                                     color: Colors.grey[200],
// //                                     child: const Icon(Icons.work, size: 40),
// //                                   );
// //                                 },
// //                               ),
// //                             ),
// //                             Expanded(
// //                               child: Padding(
// //                                 padding: const EdgeInsets.all(16.0),
// //                                 child: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text(
// //                                       career.title,
// //                                       style: const TextStyle(
// //                                         fontWeight: FontWeight.bold,
// //                                         fontSize: 18,
// //                                       ),
// //                                       maxLines: 1,
// //                                       overflow: TextOverflow.ellipsis,
// //                                     ),
// //                                     const SizedBox(height: 8),
// //                                     Text(
// //                                       career.description,
// //                                       style: TextStyle(
// //                                         color: Colors.grey[600],
// //                                         fontSize: 14,
// //                                       ),
// //                                       maxLines: 2,
// //                                       overflow: TextOverflow.ellipsis,
// //                                     ),
// //                                     const SizedBox(height: 8),
// //                                     Row(
// //                                       children: [
// //                                         Icon(Icons.trending_up, 
// //                                           size: 16, 
// //                                           color: darkBlue,
// //                                         ),
// //                                         const SizedBox(width: 4),
// //                                         Text(
// //                                           career.salaryRange,
// //                                           style: TextStyle(
// //                                             color: darkBlue,
// //                                             fontWeight: FontWeight.bold,
// //                                             fontSize: 12,
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                             Padding(
// //                               padding: const EdgeInsets.all(16.0),
// //                               child: Icon(
// //                                 Icons.arrow_forward_ios,
// //                                 size: 16,
// //                                 color: Colors.grey[400],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //             ],
// //           ),
// //         ),
        
// //         const SizedBox(height: 24.0),
        
// //         // Success Stories Section
// //         Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   const Text(
// //                     'Success Stories',
// //                     style: TextStyle(
// //                       fontSize: 20.0,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   TextButton(
// //                     onPressed: () {
// //                       setState(() {
// //                         _currentIndex = 3; // Navigate to Stories tab
// //                       });
// //                     },
// //                     child: const Text('View All'),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 12.0),
// //               if (_isLoadingStories)
// //                 const Center(child: CircularProgressIndicator())
// //               else if (_storiesError.isNotEmpty)
// //                 Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text('Error: $_storiesError'),
// //                       const SizedBox(height: 8.0),
// //                       ElevatedButton(
// //                         onPressed: _loadStories,
// //                         child: const Text('Retry'),
// //                       ),
// //                     ],
// //                   ),
// //                 )
// //               else if (_recentStories.isEmpty)
// //                 const Center(
// //                   child: Padding(
// //                     padding: EdgeInsets.all(16.0),
// //                     child: Text('No stories available yet.'),
// //                   ),
// //                 )
// //               else
// //                 SizedBox(
// //                   height: 180,
// //                   child: ListView.builder(
// //                     scrollDirection: Axis.horizontal,
// //                     itemCount: _recentStories.length > 3 ? 3 : _recentStories.length,
// //                     itemBuilder: (context, index) {
// //                       final story = _recentStories[index];
// //                       return Container(
// //                         width: 280,
// //                         margin: const EdgeInsets.only(right: 16),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(12),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black.withOpacity(0.05),
// //                               blurRadius: 8,
// //                               offset: const Offset(0, 2),
// //                             ),
// //                           ],
// //                         ),
// //                         child: InkWell(
// //                           onTap: () {
// //                             setState(() {
// //                               _currentIndex = 3; // Navigate to Stories tab
// //                             });
// //                           },
// //                           child: Row(
// //                             children: [
// //                               ClipRRect(
// //                                 borderRadius: const BorderRadius.only(
// //                                   topLeft: Radius.circular(12),
// //                                   bottomLeft: Radius.circular(12),
// //                                 ),
// //                                 child: Image.network(
// //                                   story.imagePath,
// //                                   width: 100,
// //                                   height: 180,
// //                                   fit: BoxFit.cover,
// //                                   errorBuilder: (context, error, stackTrace) {
// //                                     return Container(
// //                                       width: 100,
// //                                       height: 180,
// //                                       color: Colors.grey[200],
// //                                       child: const Icon(Icons.person, size: 40),
// //                                     );
// //                                   },
// //                                 ),
// //                               ),
// //                               Expanded(
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.all(12.0),
// //                                   child: Column(
// //                                     crossAxisAlignment: CrossAxisAlignment.start,
// //                                     children: [
// //                                       Text(
// //                                         story.name,
// //                                         style: const TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 16,
// //                                         ),
// //                                         maxLines: 1,
// //                                         overflow: TextOverflow.ellipsis,
// //                                       ),
// //                                       Text(
// //                                         '${story.role} at ${story.company}',
// //                                         style: TextStyle(
// //                                           color: Colors.grey[600],
// //                                           fontSize: 12,
// //                                         ),
// //                                         maxLines: 1,
// //                                         overflow: TextOverflow.ellipsis,
// //                                       ),
// //                                       const SizedBox(height: 8),
// //                                       Text(
// //                                         story.shortQuote,
// //                                         style: const TextStyle(
// //                                           fontStyle: FontStyle.italic,
// //                                           fontSize: 13,
// //                                         ),
// //                                         maxLines: 2,
// //                                         overflow: TextOverflow.ellipsis,
// //                                       ),
// //                                       const Spacer(),
// //                                       Row(
// //                                         children: [
// //                                           Icon(Icons.arrow_forward, 
// //                                             size: 16, 
// //                                             color: darkBlue,
// //                                           ),
// //                                           const SizedBox(width: 4),
// //                                           Text(
// //                                             'Read more',
// //                                             style: TextStyle(
// //                                               color: darkBlue,
// //                                               fontWeight: FontWeight.bold,
// //                                               fontSize: 12,
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         ),
        
// //         const SizedBox(height: 32.0),
// //       ],
// //     );
// //   }

// //   Widget _buildCareersTab() {
// //     return ListView(
// //       children: [
// //         // Search Bar
// //         Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: TextField(
// //             decoration: InputDecoration(
// //               hintText: 'Search careers...',
// //               prefixIcon: const Icon(Icons.search),
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(10.0),
// //               ),
// //               contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
// //             ),
// //             onChanged: (value) {
// //               // Search functionality would go here
// //             },
// //           ),
// //         ),

// //         const Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 16.0),
// //           child: Text(
// //             'All Careers',
// //             style: TextStyle(
// //               fontSize: 20.0,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 8.0),
        
// //         if (_isLoading)
// //           const Center(child: CircularProgressIndicator())
// //         else if (_error.isNotEmpty)
// //           Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text('Error: $_error'),
// //                 const SizedBox(height: 8.0),
// //                 ElevatedButton(
// //                   onPressed: _loadCareers,
// //                   child: const Text('Retry'),
// //                 ),
// //               ],
// //             ),
// //           )
// //         else if (_careers.isEmpty)
// //           const Center(
// //             child: Padding(
// //               padding: EdgeInsets.all(16.0),
// //               child: Text('No careers found.'),
// //             ),
// //           )
// //         else
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: GridView.builder(
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 2,
// //                 crossAxisSpacing: 16.0,
// //                 mainAxisSpacing: 16.0,
// //                 childAspectRatio: 0.75,
// //               ),
// //               itemCount: _careers.length,
// //               itemBuilder: (context, index) {
// //                 final career = _careers[index];
// //                 return Container(
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(12),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black.withOpacity(0.05),
// //                         blurRadius: 8,
// //                         offset: const Offset(0, 2),
// //                       ),
// //                     ],
// //                   ),
// //                   child: InkWell(
// //                     onTap: () {
// //                       Navigator.pushNamed(
// //                         context,
// //                         '/career-details',
// //                         arguments: career,
// //                       );
// //                     },
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         ClipRRect(
// //                           borderRadius: const BorderRadius.only(
// //                             topLeft: Radius.circular(12),
// //                             topRight: Radius.circular(12),
// //                           ),
// //                           child: Image.asset(
// //                             'assets/images/placeholder.jpg',
// //                             height: 120,
// //                             width: double.infinity,
// //                             fit: BoxFit.cover,
// //                             errorBuilder: (context, error, stackTrace) {
// //                               return Container(
// //                                 height: 120,
// //                                 color: Colors.grey[200],
// //                                 child: const Icon(Icons.work, size: 40, color: Colors.grey),
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.all(12.0),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 career.title,
// //                                 style: const TextStyle(
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 16,
// //                                 ),
// //                                 maxLines: 1,
// //                                 overflow: TextOverflow.ellipsis,
// //                               ),
// //                               const SizedBox(height: 4),
// //                               Text(
// //                                 career.description,
// //                                 style: TextStyle(
// //                                   color: Colors.grey[600],
// //                                   fontSize: 12,
// //                                 ),
// //                                 maxLines: 2,
// //                                 overflow: TextOverflow.ellipsis,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //       ],
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Welcome to CTech'),
// //         backgroundColor: darkBlue,
// //         elevation: 0,
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.quiz),
// //             onPressed: () {
// //               Navigator.pushNamed(context, '/quiz');
// //             },
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.person),
// //             onPressed: () => Navigator.pushNamed(context, '/profile'),
// //             tooltip: 'Profile',
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.settings),
// //             onPressed: () => Navigator.pushNamed(context, '/settings'),
// //             tooltip: 'Settings',
// //           ),
// //         ],
// //       ),
// //       body: IndexedStack(
// //         index: _currentIndex,
// //         children: [
// //           _buildHomeTab(),
// //           _buildCareersTab(),
// //           const TechWordsScreen(),
// //           const StoriesScreen(),
// //         ],
// //       ),
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _currentIndex,
// //         onTap: (index) => setState(() => _currentIndex = index),
// //         type: BottomNavigationBarType.fixed,
// //         backgroundColor: Colors.white,
// //         selectedItemColor: darkBlue,
// //         unselectedItemColor: Colors.grey,
// //         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
// //         unselectedLabelStyle: const TextStyle(fontSize: 11),
// //         elevation: 8,
// //         items: const [
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.home),
// //             label: 'Home',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.work),
// //             label: 'Careers',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.book),
// //             label: 'Tech Words',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.article),
// //             label: 'Stories',
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }