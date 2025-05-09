import 'package:flutter/material.dart';
import 'base_simulation.dart';

class WebDevSimulation extends BaseSimulation {
  const WebDevSimulation({Key? key}) : super(key: key);

  @override
  State<WebDevSimulation> createState() => _WebDevSimulationState();
}

class _WebDevSimulationState extends BaseSimulationState<WebDevSimulation> {
  final TextEditingController _htmlController = TextEditingController();
  final TextEditingController _cssController = TextEditingController();
  String _previewHtml = '';
  String _previewCss = '';

  @override
  void initState() {
    super.initState();
    _htmlController.text = '''
<div class="container">
  <h1>Welcome to My Website</h1>
  <p>This is a sample paragraph. Edit the HTML and CSS to see live changes!</p>
  <button class="btn">Click Me</button>
</div>
''';
    _cssController.text = '''
.container {
  padding: 20px;
  max-width: 800px;
  margin: 0 auto;
}

h1 {
  color: #2196F3;
  text-align: center;
}

p {
  font-size: 16px;
  line-height: 1.6;
  color: #333;
}

.btn {
  background-color: #2196F3;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn:hover {
  background-color: #1976D2;
}
''';
    _updatePreview();
  }

  @override
  void dispose() {
    _htmlController.dispose();
    _cssController.dispose();
    super.dispose();
  }

  void _updatePreview() {
    setState(() {
      _previewHtml = _htmlController.text;
      _previewCss = _cssController.text;
    });
  }

  Widget _buildPreview() {
    // Simple preview that mimics basic HTML elements
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title (h1)
          const Text(
            'Welcome to My Website',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Paragraph
          const Text(
            'This is a sample paragraph. Edit the HTML and CSS to see live changes!',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Click Me',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSimulationContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Web Development Simulator',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Code Editor
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'HTML',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextField(
                            controller: _htmlController,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            onChanged: (_) => _updatePreview(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CSS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextField(
                            controller: _cssController,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            onChanged: (_) => _updatePreview(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Preview
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: _buildPreview(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _updatePreview,
            child: const Text('Update Preview'),
          ),
        ],
      ),
    );
  }
} 