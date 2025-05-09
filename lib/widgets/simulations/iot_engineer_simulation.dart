import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'base_simulation.dart';

class IoTEngineerSimulation extends BaseSimulation {
  const IoTEngineerSimulation({Key? key}) : super(key: key);

  @override
  State<IoTEngineerSimulation> createState() => _IoTEngineerSimulationState();
}

class _IoTEngineerSimulationState extends BaseSimulationState<IoTEngineerSimulation> {
  final List<Map<String, dynamic>> _sensorData = [];
  bool _isRecording = false;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startSensorStream();
  }

  void _startSensorStream() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (_isRecording) {
        setState(() {
          _sensorData.add({
            'timestamp': DateTime.now().toIso8601String(),
            'type': 'accelerometer',
            'x': event.x.toStringAsFixed(2),
            'y': event.y.toStringAsFixed(2),
            'z': event.z.toStringAsFixed(2),
          });
        });
      }
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (_isRecording) {
        setState(() {
          _sensorData.add({
            'timestamp': DateTime.now().toIso8601String(),
            'type': 'gyroscope',
            'x': event.x.toStringAsFixed(2),
            'y': event.y.toStringAsFixed(2),
            'z': event.z.toStringAsFixed(2),
          });
        });
      }
    });
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _startTime = DateTime.now();
        _sensorData.clear();
      }
    });
  }

  void _clearData() {
    setState(() {
      _sensorData.clear();
      _startTime = null;
    });
  }

  String _getDuration() {
    if (_startTime == null) return '00:00';
    final duration = DateTime.now().difference(_startTime!);
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget buildSimulationContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'IoT Sensor Data Logger',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _toggleRecording,
                        icon: Icon(_isRecording ? Icons.stop : Icons.play_arrow),
                        label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRecording ? Colors.red : Colors.green,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _clearData,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Data'),
                      ),
                    ],
                  ),
                  if (_isRecording) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Recording Time: ${_getDuration()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sensor Data Log',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _sensorData.isEmpty
                          ? const Center(
                              child: Text('No data recorded yet'),
                            )
                          : ListView.builder(
                              itemCount: _sensorData.length,
                              itemBuilder: (context, index) {
                                final data = _sensorData[index];
                                return ListTile(
                                  title: Text(
                                    '${data['type']} (${data['timestamp'].split('T')[1].split('.')[0]})',
                                  ),
                                  subtitle: Text(
                                    'X: ${data['x']}, Y: ${data['y']}, Z: ${data['z']}',
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 