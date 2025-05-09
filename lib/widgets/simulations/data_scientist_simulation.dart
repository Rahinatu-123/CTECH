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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: _pickAndAnalyzeFile,
            child: const Text('Select Data File (CSV/JSON)'),
          ),
          const SizedBox(height: 16),
          if (_columns.isNotEmpty) ...[
            DropdownButton<String>(
              value: _selectedColumn,
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
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateDataPoints(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
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