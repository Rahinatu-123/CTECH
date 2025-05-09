import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'base_simulation.dart';

class MobileDevSimulation extends BaseSimulation {
  const MobileDevSimulation({Key? key}) : super(key: key);

  @override
  State<MobileDevSimulation> createState() => _MobileDevSimulationState();
}

class _MobileDevSimulationState extends BaseSimulationState<MobileDevSimulation> {
  Position? _currentPosition;
  Map<String, dynamic> _weatherData = {
    'temperature': 0.0,
    'condition': '',
    'icon': '',
    'humidity': 0,
    'windSpeed': 0.0,
    'feelsLike': 0.0,
    'forecast': [],
  };
  final bool _isLoading = false;
  bool _showMap = false;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setLoading(true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setError('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setError('Location permission permanently denied');
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _simulateWeatherData();
    } catch (e) {
      setError('Error getting location: $e');
    } finally {
      setLoading(false);
    }
  }

  void _toggleMap() {
    setState(() {
      _showMap = !_showMap;
    });
  }

  void _simulateWeatherData() {
    if (_currentPosition == null) return;

    final lat = _currentPosition!.latitude;
    String condition;
    String icon;
    double baseTemp;

    // Simulate weather based on latitude
    if (lat > 60) {
      condition = 'Snowy';
      icon = '❄️';
      baseTemp = -5.0;
    } else if (lat > 30) {
      condition = 'Cloudy';
      icon = '☁️';
      baseTemp = 15.0;
    } else if (lat > 0) {
      condition = 'Sunny';
      icon = '☀️';
      baseTemp = 25.0;
    } else if (lat > -30) {
      condition = 'Hot';
      icon = '🌡️';
      baseTemp = 35.0;
    } else {
      condition = 'Cold';
      icon = '❄️';
      baseTemp = -10.0;
    }

    // Generate random variations
    final random = DateTime.now().millisecondsSinceEpoch % 10;
    final tempVariation = (random - 5) * 0.5;
    final temperature = baseTemp + tempVariation;
    final feelsLike = temperature + (random % 3 - 1);
    final humidity = 40 + (random * 5);
    final windSpeed = 5.0 + (random * 2);

    // Generate forecast
    final forecast = List.generate(5, (index) {
      final dayTemp = temperature + (index * 2 - 2);
      return {
        'day': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'][index],
        'temp': dayTemp.toStringAsFixed(1),
        'icon': index % 2 == 0 ? icon : '🌤️',
      };
    });

    setState(() {
      _weatherData = {
        'temperature': temperature,
        'condition': condition,
        'icon': icon,
        'humidity': humidity,
        'windSpeed': windSpeed,
        'feelsLike': feelsLike,
        'forecast': forecast,
      };
    });
  }

  @override
  Widget buildSimulationContent() {
    if (_showMap && _currentPosition != null) {
      return Center(
        child: Container(
          width: 300,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.grey[800]!, width: 8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: _toggleMap,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        width: 300,
        height: 600,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey[800]!, width: 8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            color: Colors.blue[900],
            child: Column(
              children: [
                // Status bar
                Container(
                  height: 30,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '12:00',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      Row(
                        children: [
                          Icon(Icons.signal_cellular_alt, color: Colors.grey[300], size: 16),
                          const SizedBox(width: 4),
                          Icon(Icons.wifi, color: Colors.grey[300], size: 16),
                          const SizedBox(width: 4),
                          Icon(Icons.battery_full, color: Colors.grey[300], size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
                // Weather app content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Location
                          GestureDetector(
                            onTap: _toggleMap,
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  '${_currentPosition?.latitude.toStringAsFixed(2)}°N, ${_currentPosition?.longitude.toStringAsFixed(2)}°E',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.map, color: Colors.white70, size: 16),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Current weather
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  _weatherData['icon'],
                                  style: const TextStyle(fontSize: 64),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_weatherData['temperature'].toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _weatherData['condition'],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  'Feels like ${_weatherData['feelsLike'].toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Weather details
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildWeatherDetail(
                                  Icons.water_drop,
                                  'Humidity',
                                  '${_weatherData['humidity']}%',
                                ),
                                _buildWeatherDetail(
                                  Icons.air,
                                  'Wind',
                                  '${_weatherData['windSpeed'].toStringAsFixed(1)} km/h',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Forecast
                          const Text(
                            '5-Day Forecast',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _weatherData['forecast'].length,
                              itemBuilder: (context, index) {
                                final day = _weatherData['forecast'][index];
                                return Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 16),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        day['day'],
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        day['icon'],
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${day['temp']}°',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
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
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 