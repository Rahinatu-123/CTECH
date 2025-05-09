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
  String getInstructions() {
    return 'Connect and program virtual IoT devices. Learn about sensors, actuators, and how to build connected systems.';
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
            'IoT Sensor Simulator',
            style: TextStyle(
              fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenSize.height * 0.01),
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(screenSize.width * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sensor Data',
                      style: TextStyle(
                        fontSize: isSmallScreen ? screenSize.width * 0.03 : screenSize.width * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.005),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _sensorData.length,
                        itemBuilder: (context, index) {
                          final data = _sensorData[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: screenSize.height * 0.005),
                            child: Padding(
                              padding: EdgeInsets.all(screenSize.width * 0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        _getSensorIcon(data['type']),
                                        size: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                                        color: _getSensorColor(data['type']),
                                      ),
                                      SizedBox(width: screenSize.width * 0.01),
                                      Expanded(
                                        child: Text(
                                          data['type'],
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${data['x']} ${_getSensorUnit(data['type'])}',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                                          color: _getSensorColor(data['type']),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenSize.height * 0.002),
                                  Text(
                                    'Time: ${_formatTimestamp(data['timestamp'])}',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? screenSize.width * 0.02 : screenSize.width * 0.015,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
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

  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  IconData _getSensorIcon(String type) {
    if (type == 'accelerometer') {
      return Icons.speed;
    } else if (type == 'gyroscope') {
      return Icons.rotate_right;
    } else {
      throw Exception('Unknown sensor type');
    }
  }

  Color _getSensorColor(String type) {
    if (type == 'accelerometer') {
      return Colors.blue;
    } else if (type == 'gyroscope') {
      return Colors.green;
    } else {
      throw Exception('Unknown sensor type');
    }
  }

  String _getSensorUnit(String type) {
    if (type == 'accelerometer') {
      return 'm/s²';
    } else if (type == 'gyroscope') {
      return '°/s';
    } else {
      throw Exception('Unknown sensor type');
    }
  }
} 