import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'base_simulation.dart';

class MobileDevSimulation extends BaseSimulation {
  const MobileDevSimulation({Key? key}) : super(key: key);

  @override
  _MobileDevSimulationState createState() => _MobileDevSimulationState();
}

class _MobileDevSimulationState extends BaseSimulationState<MobileDevSimulation> {
  final TextEditingController _codeController = TextEditingController();
  bool _isDarkMode = false;
  String _previewCode = '';
  List<String> _availableResources = [];
  String _selectedResource = '';
  String _errorMessage = '';
  bool _isLoading = false;
  final List<Map<String, String>> _widgetTemplates = [
    {
      'name': 'Button',
      'code': '''
ElevatedButton(
  onPressed: () {},
  child: Text('Click Me'),
),
'''
    },
    {
      'name': 'Card',
      'code': '''
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Card Title', style: TextStyle(fontSize: 20)),
        SizedBox(height: 8),
        Text('Card Description'),
      ],
    ),
  ),
),
'''
    },
    {
      'name': 'List View',
      'code': '''
ListView.builder(
  itemCount: 5,
  itemBuilder: (context, index) {
    return ListTile(
      leading: Icon(Icons.star),
      title: Text('Item \${index + 1}'),
      subtitle: Text('Description for item \${index + 1}'),
    );
  },
),
'''
    },
    {
      'name': 'Form',
      'code': '''
Form(
  child: Column(
    children: [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 16),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
        obscureText: true,
      ),
    ],
  ),
),
'''
    }
  ];

  @override
  void initState() {
    super.initState();
    _codeController.text = _getDefaultTemplate();
    _updatePreview();
    _loadResources();
  }

  String _getDefaultTemplate() {
    return '''import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Hello, Flutter!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}''';
  }

  Future<void> _loadResources() async {
    setState(() => _isLoading = true);
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      setState(() {
        _availableResources = manifestMap.keys
            .where((String key) => key.startsWith('assets/'))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading resources: $e';
        _isLoading = false;
      });
    }
  }

  void _updatePreview() {
    setState(() {
      _previewCode = _codeController.text;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _addWidget(String widgetCode) {
    final currentCode = _codeController.text;
    final insertIndex = currentCode.lastIndexOf('children: const [');
    if (insertIndex != -1) {
      final newCode = currentCode.substring(0, insertIndex + 17) +
          '\n            $widgetCode,' +
          currentCode.substring(insertIndex + 17);
      _codeController.text = newCode;
      _updatePreview();
    }
  }

  void _resetCode() {
    _codeController.text = _getDefaultTemplate();
    _updatePreview();
  }

  Future<void> _addResourceToCode() async {
    if (_selectedResource.isEmpty) return;

    final resourceCode = '''
Image.asset(
  '$_selectedResource',
  width: 200,
  height: 200,
  fit: BoxFit.contain,
),
''';

    _insertCodeAtCursor(resourceCode);
  }

  void _insertCodeAtCursor(String code) {
    final currentText = _codeController.text;
    final insertIndex = currentText.indexOf('children: [');
    if (insertIndex != -1) {
      _codeController.text = currentText.substring(0, insertIndex + 10) +
          '\n' + code + '\n' +
          currentText.substring(insertIndex + 10);
      _updatePreview();
    }
  }

  void _addWidgetTemplate(String code) {
    _insertCodeAtCursor(code);
  }

  @override
  Widget buildSimulationContent() {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isDarkMode ? Colors.grey[800] : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: _isDarkMode ? Colors.amber : Colors.grey[700],
                  ),
                  onPressed: _toggleTheme,
                  tooltip: 'Toggle Theme',
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _resetCode,
                  tooltip: 'Reset Code',
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Widget',
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'text',
                      child: Text('Text Widget'),
                    ),
                    const PopupMenuItem(
                      value: 'button',
                      child: Text('Elevated Button'),
                    ),
                    const PopupMenuItem(
                      value: 'image',
                      child: Text('Image Widget'),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'text':
                        _addWidget('Text(\'New Text\', style: TextStyle(fontSize: 18))');
                        break;
                      case 'button':
                        _addWidget('ElevatedButton(onPressed: () {}, child: Text(\'Click Me\'))');
                        break;
                      case 'image':
                        _addWidget('Image.network(\'https://picsum.photos/200\', width: 100, height: 100)');
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Code Editor
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    child: TextField(
                      controller: _codeController,
                      maxLines: null,
                      expands: true,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: InputBorder.none,
                      ),
                      onChanged: (_) => _updatePreview(),
                    ),
                  ),
                ),
                // Preview
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Phone Frame
                        Center(
                          child: Container(
                            width: 300,
                            height: 600,
                            decoration: BoxDecoration(
                              color: _isDarkMode ? Colors.grey[900] : Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: _isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                                width: 8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: MaterialApp(
                                debugShowCheckedModeBanner: false,
                                theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
                                home: Scaffold(
                                  body: Center(
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Preview',
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Your Flutter app will appear here',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Notch
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 150,
                              height: 30,
                              decoration: BoxDecoration(
                                color: _isDarkMode ? Colors.grey[900] : Colors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  String getInstructions() {
    return 'Write Flutter code in the editor and see the preview in real-time. Use the toolbar to add widgets, toggle dark mode, or reset the code.';
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
} 