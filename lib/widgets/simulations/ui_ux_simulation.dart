import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'base_simulation.dart';

class UIUXSimulation extends BaseSimulation {
  const UIUXSimulation({Key? key}) : super(key: key);

  @override
  State<UIUXSimulation> createState() => _UIUXSimulationState();
}

class _UIUXSimulationState extends BaseSimulationState<UIUXSimulation> {
  Color _primaryColor = Colors.blue;
  Color _secondaryColor = Colors.orange;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;
  String _selectedFont = 'Roboto';
  double _fontSize = 16.0;
  bool _isDarkMode = false;

  final List<String> _fonts = [
    'Roboto',
    'OpenSans',
    'Montserrat',
    'Poppins',
    'Lato',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the simulation
    setLoading(false);
  }

  TextStyle _getTextStyle({bool isHeading = false}) {
    TextStyle baseStyle = TextStyle(
      fontSize: isHeading ? _fontSize * 1.5 : _fontSize,
      color: _textColor,
    );

    switch (_selectedFont) {
      case 'Roboto':
        return GoogleFonts.roboto(textStyle: baseStyle);
      case 'OpenSans':
        return GoogleFonts.openSans(textStyle: baseStyle);
      case 'Montserrat':
        return GoogleFonts.montserrat(textStyle: baseStyle);
      case 'Poppins':
        return GoogleFonts.poppins(textStyle: baseStyle);
      case 'Lato':
        return GoogleFonts.lato(textStyle: baseStyle);
      default:
        return baseStyle;
    }
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      if (_isDarkMode) {
        _backgroundColor = Colors.grey[900]!;
        _textColor = Colors.white;
      } else {
        _backgroundColor = Colors.white;
        _textColor = Colors.black;
      }
    });
  }

  @override
  Widget buildSimulationContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'UI/UX Design Simulator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Color Palette Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Color Palette',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Primary Color'),
                              ColorPicker(
                                color: _primaryColor,
                                onColorChanged: (color) {
                                  setState(() => _primaryColor = color);
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Secondary Color'),
                              ColorPicker(
                                color: _secondaryColor,
                                onColorChanged: (color) {
                                  setState(() => _secondaryColor = color);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Typography Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Typography',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<String>(
                      value: _selectedFont,
                      isExpanded: true,
                      items: _fonts.map((font) {
                        return DropdownMenuItem(
                          value: font,
                          child: Text(font),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedFont = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Font Size: '),
                        Expanded(
                          child: Slider(
                            value: _fontSize,
                            min: 12,
                            max: 32,
                            divisions: 20,
                            label: _fontSize.round().toString(),
                            onChanged: (value) {
                              setState(() => _fontSize = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Preview Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sample Heading',
                            style: _getTextStyle(isHeading: true).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This is a sample paragraph text that demonstrates how the selected typography and colors work together in a real interface.',
                            style: _getTextStyle(),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                            ),
                            child: const Text('Primary Button'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _secondaryColor,
                            ),
                            child: const Text('Secondary Button'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: (value) => _toggleDarkMode(),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorPicker extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    Key? key,
    required this.color,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              _buildColorSlider(
                'Red',
                color.red,
                (value) => Color.fromARGB(
                  color.alpha,
                  value.round(),
                  color.green,
                  color.blue,
                ),
              ),
              _buildColorSlider(
                'Green',
                color.green,
                (value) => Color.fromARGB(
                  color.alpha,
                  color.red,
                  value.round(),
                  color.blue,
                ),
              ),
              _buildColorSlider(
                'Blue',
                color.blue,
                (value) => Color.fromARGB(
                  color.alpha,
                  color.red,
                  color.green,
                  value.round(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorSlider(String label, int value, Color Function(double) colorBuilder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 255,
          divisions: 255,
          label: value.toString(),
          onChanged: (newValue) {
            onColorChanged(colorBuilder(newValue));
          },
        ),
      ],
    );
  }
} 