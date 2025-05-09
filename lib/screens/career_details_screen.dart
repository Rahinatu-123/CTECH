import 'package:flutter/material.dart';
import '../models/career.dart';
import 'simulation_screen.dart';

class CareerDetailsScreen extends StatelessWidget {
  final Career career;

  const CareerDetailsScreen({super.key, required this.career});

  String _getSimulationType(String title) {
    // Use the career's simulationType property
    return career.simulationType ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(career.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(career.imagePath ?? 'https://via.placeholder.com/800x400'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Description
                  Text(
                    career.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    career.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Skills Section
                  const Text(
                    'Required Skills',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: career.skills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Education Section
                  const Text(
                    'Education Requirements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    career.education,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // Salary Range Section
                  const Text(
                    'Salary Range',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    career.salaryRange,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // Job Outlook Section
                  const Text(
                    'Job Outlook',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    career.jobOutlook,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  // Try Career Simulation Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SimulationScreen(
                              simulationType: _getSimulationType(career.title),
                              careerTitle: career.title,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Try Career Simulation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCareerIcon(String title) {
    final lowercaseTitle = title.toLowerCase();
    if (lowercaseTitle.contains('developer') ||
        lowercaseTitle.contains('programmer')) {
      return Icons.code;
    } else if (lowercaseTitle.contains('designer') ||
        lowercaseTitle.contains('ui')) {
      return Icons.design_services;
    } else if (lowercaseTitle.contains('data') ||
        lowercaseTitle.contains('analyst')) {
      return Icons.analytics;
    } else if (lowercaseTitle.contains('cloud') ||
        lowercaseTitle.contains('network')) {
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
