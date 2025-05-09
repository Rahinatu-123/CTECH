import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'base_simulation.dart';

class DataScientistSimulation extends BaseSimulation {
  const DataScientistSimulation({Key? key}) : super(key: key);

  @override
  State<DataScientistSimulation> createState() => _DataScientistSimulationState();
}

class _DataScientistSimulationState extends BaseSimulationState<DataScientistSimulation> {
  List<Map<String, dynamic>> _data = [];
  String _selectedColumn = '';
  List<String> _columns = [];
  final bool _isAnalyzing = false;

  @override
  String getInstructions() {
    return 'Analyze and visualize data using various statistical methods. Learn about data cleaning, analysis techniques, and creating meaningful visualizations.';
  }

  Future<void> _pickAndAnalyzeFile() async {
    setLoading(true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'json'],
      );

      if (result == null) {
        setError('No file selected');
        return;
      }

      final file = result.files.first;
      final bytes = file.bytes;
      if (bytes == null) {
        setError('Could not read file');
        return;
      }

      final content = utf8.decode(bytes);
      if (file.extension == 'csv') {
        _parseCSV(content);
      } else if (file.extension == 'json') {
        _parseJSON(content);
      }

      if (_data.isNotEmpty) {
        _columns = _data.first.keys.toList();
        _selectedColumn = _columns.first;
      }
    } catch (e) {
      setError('Error analyzing file: $e');
    } finally {
      setLoading(false);
    }
  }

  void _parseCSV(String content) {
    final lines = content.split('\n');
    if (lines.isEmpty) {
      setError('Empty CSV file');
      return;
    }

    final headers = lines[0].split(',');
    _data = [];

    for (var i = 1; i < lines.length; i++) {
      if (lines[i].trim().isEmpty) continue;
      final values = lines[i].split(',');
      if (values.length != headers.length) continue;

      final row = <String, dynamic>{};
      for (var j = 0; j < headers.length; j++) {
        row[headers[j]] = values[j];
      }
      _data.add(row);
    }
  }

  void _parseJSON(String content) {
    try {
      final List<dynamic> jsonData = json.decode(content);
      _data = jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      setError('Invalid JSON format');
    }
  }

  List<FlSpot> _generateDataPoints() {
    if (_data.isEmpty || _selectedColumn.isEmpty) return [];

    final values = _data.map((row) {
      final value = row[_selectedColumn];
      if (value is num) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (_) {
          return 0.0;
        }
      }
      return 0.0;
    }).toList();

    return List.generate(values.length, (index) => FlSpot(index.toDouble(), values[index]));
  }

  @override
  Widget buildSimulationContent() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Data Analysis Simulator',
            style: TextStyle(
              fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenSize.height * 0.01),
          ElevatedButton(
            onPressed: _pickAndAnalyzeFile,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.02,
                vertical: screenSize.height * 0.01,
              ),
            ),
            child: Text(
              'Select Data File (CSV/JSON)',
              style: TextStyle(
                fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          if (_columns.isNotEmpty) ...[
            DropdownButton<String>(
              value: _selectedColumn,
              isExpanded: true,
              style: TextStyle(fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015),
              items: _columns.map((column) {
                return DropdownMenuItem(
                  value: column,
                  child: Text(column),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedColumn = value;
                  });
                }
              },
            ),
            SizedBox(height: screenSize.height * 0.01),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? screenSize.width * 0.02 : screenSize.width * 0.015,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: isSmallScreen ? screenSize.width * 0.02 : screenSize.width * 0.015,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateDataPoints(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: isSmallScreen ? 1.5 : 2,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 