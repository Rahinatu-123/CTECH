import 'package:flutter/material.dart';

class MobileDevSimulation extends StatefulWidget {
  const MobileDevSimulation({Key? key}) : super(key: key);

  @override
  _MobileDevSimulationState createState() => _MobileDevSimulationState();
}

class _MobileDevSimulationState extends State<MobileDevSimulation> {
  final TextEditingController _dartController = TextEditingController();
  String _previewCode = '';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _dartController.text = '''
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
''';
    _updatePreview();
  }

  void _updatePreview() {
    setState(() {
      _previewCode = _dartController.text;
    });
  }

  @override
  void dispose() {
    _dartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Dart Code',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Switch(
                            value: _isDarkMode,
                            onChanged: (value) {
                              setState(() {
                                _isDarkMode = value;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isDarkMode ? Colors.grey[900] : Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _dartController,
                          maxLines: null,
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white : Colors.black,
                            fontFamily: 'monospace',
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          onChanged: (_) => _updatePreview(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _previewCode,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                            ),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add a new widget
                  final newWidget = '''
Container(
  padding: EdgeInsets.all(16),
  child: Text('New Widget'),
)
''';
                  final currentText = _dartController.text;
                  final insertIndex = currentText.indexOf('child:');
                  if (insertIndex != -1) {
                    _dartController.text = currentText.substring(0, insertIndex + 6) +
                        '\n' + newWidget + '\n' +
                        currentText.substring(insertIndex + 6);
                    _updatePreview();
                  }
                },
                child: const Text('Add Widget'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Reset to default code
                  _dartController.text = '''
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
''';
                  _updatePreview();
                },
                child: const Text('Reset Code'),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 