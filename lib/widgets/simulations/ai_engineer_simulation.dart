import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'base_simulation.dart';

class AIEngineerSimulation extends BaseSimulation {
  const AIEngineerSimulation({Key? key}) : super(key: key);

  @override
  State<AIEngineerSimulation> createState() => _AIEngineerSimulationState();
}

class _AIEngineerSimulationState extends BaseSimulationState<AIEngineerSimulation> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  String _prediction = 'No prediction yet';
  double _confidence = 0.0;
  File? _imageFile;
  final List<String> _categories = [
    'Person',
    'Car',
    'Dog',
    'Cat',
    'Building',
    'Tree',
    'Phone',
    'Computer',
    'Book',
    'Chair'
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    setLoading(true);
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setError('No cameras available on this device');
        return;
      }

      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (!mounted) return;
      setLoading(false);
    } catch (e) {
      setError('Failed to initialize camera: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
      _classifyImage();
    }
  }

  Future<void> _classifyImage() async {
    if (_imageFile == null) {
      setError('No image selected');
      return;
    }

    setLoading(true);
    try {
      // Simulate AI processing delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate classification with random category and confidence
      final random = DateTime.now().millisecondsSinceEpoch;
      final categoryIndex = random % _categories.length;
      final confidence = 0.5 + (random % 50) / 100.0; // Random confidence between 0.5 and 1.0
      
      setState(() {
        _prediction = _categories[categoryIndex];
        _confidence = confidence;
      });
    } catch (e) {
      setError('Failed to classify image: $e');
    } finally {
      setLoading(false);
    }
  }

  @override
  String getInstructions() {
    return 'Train a simple machine learning model by adjusting parameters and observing the results. Learn about data preprocessing, model training, and evaluation in AI development.';
  }

  @override
  Widget buildSimulationContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'AI Image Classification',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_imageFile != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _imageFile!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick Image'),
              ),
              if (_imageFile != null)
                ElevatedButton.icon(
                  onPressed: _classifyImage,
                  icon: const Icon(Icons.analytics),
                  label: const Text('Classify'),
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_prediction != 'No prediction yet') ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Prediction: $_prediction',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: ${(_confidence * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: _confidence > 0.8
                            ? Colors.green
                            : _confidence > 0.6
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _confidence,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _confidence > 0.8
                            ? Colors.green
                            : _confidence > 0.6
                                ? Colors.orange
                                : Colors.red,
                      ),
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
} 