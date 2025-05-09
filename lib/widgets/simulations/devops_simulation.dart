import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'base_simulation.dart';

class DevOpsSimulation extends BaseSimulation {
  const DevOpsSimulation({Key? key}) : super(key: key);

  @override
  State<DevOpsSimulation> createState() => _DevOpsSimulationState();
}

class _DevOpsSimulationState extends BaseSimulationState<DevOpsSimulation> {
  final List<Map<String, dynamic>> _pipelineStages = [
    {
      'name': 'Build',
      'status': 'pending',
      'icon': Icons.build,
      'color': Colors.orange,
      'logs': [],
    },
    {
      'name': 'Test',
      'status': 'pending',
      'icon': Icons.bug_report,
      'color': Colors.purple,
      'logs': [],
    },
    {
      'name': 'Deploy',
      'status': 'pending',
      'icon': Icons.rocket_launch,
      'color': Colors.blue,
      'logs': [],
    },
  ];

  bool _isRunning = false;
  Timer? _pipelineTimer;
  int _currentStage = 0;

  @override
  void dispose() {
    _pipelineTimer?.cancel();
    super.dispose();
  }

  void _startPipeline() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _currentStage = 0;
      for (var stage in _pipelineStages) {
        stage['status'] = 'pending';
        stage['logs'] = [];
      }
    });

    _runNextStage();
  }

  void _runNextStage() {
    if (_currentStage >= _pipelineStages.length) {
      setState(() {
        _isRunning = false;
      });
      return;
    }

    final stage = _pipelineStages[_currentStage];
    setState(() {
      stage['status'] = 'running';
      stage['logs'] = ['Starting ${stage['name']} stage...'];
    });

    // Simulate stage execution
    int step = 1;
    _pipelineTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (step > 3) {
        timer.cancel();
        _completeStage();
        return;
      }

      setState(() {
        stage['logs'].add('Step $step: ${_getRandomLogMessage(stage['name'])}');
      });
      step++;
    });
  }

  void _completeStage() {
    final stage = _pipelineStages[_currentStage];
    final success = _random.nextBool();
    
    setState(() {
      stage['status'] = success ? 'success' : 'failed';
      stage['logs'].add(success ? 'Stage completed successfully!' : 'Stage failed!');
    });

    if (success) {
      _currentStage++;
      _runNextStage();
    } else {
      setState(() {
        _isRunning = false;
      });
    }
  }

  String _getRandomLogMessage(String stage) {
    final messages = {
      'Build': [
        'Installing dependencies...',
        'Compiling source code...',
        'Creating build artifacts...',
        'Optimizing bundle size...',
      ],
      'Test': [
        'Running unit tests...',
        'Executing integration tests...',
        'Checking code coverage...',
        'Running performance tests...',
      ],
      'Deploy': [
        'Preparing deployment package...',
        'Uploading to staging environment...',
        'Running health checks...',
        'Updating production environment...',
      ],
    };

    final stageMessages = messages[stage] ?? [];
    return stageMessages[_random.nextInt(stageMessages.length)];
  }

  final Random _random = Random();

  @override
  Widget buildSimulationContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'CI/CD Pipeline Simulator',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Pipeline Stages
          Expanded(
            child: ListView.builder(
              itemCount: _pipelineStages.length,
              itemBuilder: (context, index) {
                final stage = _pipelineStages[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              stage['icon'],
                              color: stage['color'],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              stage['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            _buildStatusIndicator(stage['status']),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (stage['logs'].isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var log in stage['logs'])
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      log,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
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
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isRunning ? null : _startPipeline,
            child: Text(_isRunning ? 'Pipeline Running...' : 'Start Pipeline'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'success':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'failed':
        color = Colors.red;
        icon = Icons.error;
        break;
      case 'running':
        color = Colors.blue;
        icon = Icons.sync;
        break;
      default:
        color = Colors.grey;
        icon = Icons.hourglass_empty;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          status.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 