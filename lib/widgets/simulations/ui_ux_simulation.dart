import 'package:flutter/material.dart';

class UIUXSimulation extends StatefulWidget {
  const UIUXSimulation({Key? key}) : super(key: key);

  @override
  _UIUXSimulationState createState() => _UIUXSimulationState();
}

class _UIUXSimulationState extends State<UIUXSimulation> {
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;
  double _fontSize = 16.0;
  String _fontFamily = 'Arial';
  bool _isBold = false;
  bool _isItalic = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Design Controls',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Background Color
                      const Text('Background Color'),
                      ColorPicker(
                        selectedColor: _backgroundColor,
                        onColorChanged: (color) {
                          setState(() {
                            _backgroundColor = color;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Text Color
                      const Text('Text Color'),
                      ColorPicker(
                        selectedColor: _textColor,
                        onColorChanged: (color) {
                          setState(() {
                            _textColor = color;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Font Size
                      const Text('Font Size'),
                      Slider(
                        value: _fontSize,
                        min: 12,
                        max: 32,
                        divisions: 20,
                        label: _fontSize.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            _fontSize = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Font Family
                      const Text('Font Family'),
                      DropdownButton<String>(
                        value: _fontFamily,
                        items: ['Arial', 'Times New Roman', 'Courier New']
                            .map((font) => DropdownMenuItem(
                                  value: font,
                                  child: Text(font),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _fontFamily = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Text Style
                      Row(
                        children: [
                          Checkbox(
                            value: _isBold,
                            onChanged: (value) {
                              setState(() {
                                _isBold = value ?? false;
                              });
                            },
                          ),
                          const Text('Bold'),
                          const SizedBox(width: 16),
                          Checkbox(
                            value: _isItalic,
                            onChanged: (value) {
                              setState(() {
                                _isItalic = value ?? false;
                              });
                            },
                          ),
                          const Text('Italic'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  color: _backgroundColor,
                  child: Center(
                    child: Text(
                      'Preview Text',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: _fontSize,
                        fontFamily: _fontFamily,
                        fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                        fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
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

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorChanged;

  const ColorPicker({
    Key? key,
    required this.selectedColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
        Colors.black,
        Colors.white,
      ].map((color) {
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: selectedColor == color ? Colors.blue : Colors.grey,
                width: selectedColor == color ? 2 : 1,
              ),
              shape: BoxShape.circle,
            ),
          ),
        );
      }).toList(),
    );
  }
} 