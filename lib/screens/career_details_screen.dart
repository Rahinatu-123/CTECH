import 'package:flutter/material.dart';
import '../models/career.dart';
import 'simulation_screen.dart';

class CareerDetailsScreen extends StatelessWidget {
  final Career career;

  const CareerDetailsScreen({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(career.title),
              background: Container(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(
                  _getCareerIcon(career.title),
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    context,
                    'Description',
                    career.description,
                    Icons.description,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Required Skills',
                    null,
                    Icons.psychology,
                    chips: career.skills.map((skill) => skill.trim()).toList(),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Education',
                    career.education,
                    Icons.school,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Salary Range',
                    career.salaryRange,
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Job Outlook',
                    career.jobOutlook,
                    Icons.trending_up,
                  ),
                  const SizedBox(height: 32),
                  if (career.tools != null && career.tools!.isNotEmpty)
                    _buildSection(
                      context,
                      'Tools & Technologies',
                      null,
                      Icons.build,
                      chips: career.tools!,
                    ),
                  const SizedBox(height: 32),
                  if (career.simulationType != null) ...[
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => SimulationScreen(
                                    simulationType: career.simulationType!,
                                    careerTitle: career.title,
                                  ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('Try Simulation'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Career Insights',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'This career path offers opportunities for growth and development in the tech industry. Consider exploring related roles and continuous learning to advance your career.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String? content,
    IconData icon, {
    List<String>? chips,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (content != null)
          Text(content, style: Theme.of(context).textTheme.bodyLarge),
        if (chips != null) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                chips.map((item) {
                  return Chip(
                    label: Text(item),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                  );
                }).toList(),
          ),
        ],
      ],
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
