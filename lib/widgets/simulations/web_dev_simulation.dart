import 'package:flutter/material.dart';

class WebDevSimulation extends StatefulWidget {
  const WebDevSimulation({Key? key}) : super(key: key);

  @override
  _WebDevSimulationState createState() => _WebDevSimulationState();
}

class _WebDevSimulationState extends State<WebDevSimulation> {
  final TextEditingController _htmlController = TextEditingController();
  final TextEditingController _cssController = TextEditingController();
  String _previewHtml = '';

  @override
  void initState() {
    super.initState();
    _htmlController.text = '''
<!DOCTYPE html>
<html>
<head>
  <title>My Web Page</title>
</head>
<body>
  <h1>Welcome to My Page</h1>
  <p>This is a paragraph.</p>
</body>
</html>
''';
    _cssController.text = '''
body {
  font-family: Arial, sans-serif;
  margin: 20px;
}
h1 {
  color: blue;
}
p {
  color: gray;
}
''';
    _updatePreview();
  }

  void _updatePreview() {
    setState(() {
      _previewHtml = '''
<!DOCTYPE html>
<html>
<head>
  <style>
    ${_cssController.text}
  </style>
</head>
${_htmlController.text}
</html>
''';
    });
  }

  @override
  void dispose() {
    _htmlController.dispose();
    _cssController.dispose();
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'HTML',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _htmlController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                        onChanged: (_) => _updatePreview(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'CSS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _cssController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                        onChanged: (_) => _updatePreview(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
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
                    child: Text(_previewHtml),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 