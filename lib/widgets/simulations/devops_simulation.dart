import 'package:flutter/material.dart';

class DevOpsSimulation extends StatefulWidget {
  const DevOpsSimulation({Key? key}) : super(key: key);

  @override
  _DevOpsSimulationState createState() => _DevOpsSimulationState();
}

class _DevOpsSimulationState extends State<DevOpsSimulation> {
  bool _isBuilding = false;
  bool _isTesting = false;
  bool _isDeploying = false;
  String _buildStatus = 'Not Started';
  String _testStatus = 'Not Started';
  String _deployStatus = 'Not Started';
  List<String> _logs = [];

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().split('.')[0]}: $message');
    });
  }

  Future<void> _startPipeline() async {
    setState(() {
      _isBuilding = true;
      _buildStatus = 'In Progress';
      _addLog('Starting build process...');
    });

    // Simulate build
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isBuilding = false;
      _buildStatus = 'Completed';
      _isTesting = true;
      _testStatus = 'In Progress';
      _addLog('Build completed successfully');
      _addLog('Starting tests...');
    });

    // Simulate testing
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isTesting = false;
      _testStatus = 'Completed';
      _isDeploying = true;
      _deployStatus = 'In Progress';
      _addLog('Tests passed successfully');
      _addLog('Starting deployment...');
    });

    // Simulate deployment
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isDeploying = false;
      _deployStatus = 'Completed';
      _addLog('Deployment completed successfully');
    });
  }

  void _resetPipeline() {
    setState(() {
      _isBuilding = false;
      _isTesting = false;
      _isDeploying = false;
      _buildStatus = 'Not Started';
      _testStatus = 'Not Started';
      _deployStatus = 'Not Started';
      _logs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'CI/CD Pipeline',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildPipelineStage(
                              'Build',
                              Icons.build,
                              _isBuilding,
                              _buildStatus,
                            ),
                            const Divider(),
                            _buildPipelineStage(
                              'Test',
                              Icons.bug_report,
                              _isTesting,
                              _testStatus,
                            ),
                            const Divider(),
                            _buildPipelineStage(
                              'Deploy',
                              Icons.rocket_launch,
                              _isDeploying,
                              _deployStatus,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Pipeline Logs',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                _logs[index],
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isBuilding || _isTesting || _isDeploying
                    ? null
                    : _startPipeline,
                child: const Text('Start Pipeline'),
              ),
              ElevatedButton(
                onPressed: _resetPipeline,
                child: const Text('Reset Pipeline'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPipelineStage(
    String title,
    IconData icon,
    bool isActive,
    String status,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: isActive ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: isActive ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }
} 