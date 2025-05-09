import 'package:flutter/material.dart';

abstract class BaseSimulation extends StatefulWidget {
  const BaseSimulation({Key? key}) : super(key: key);

  @override
  State<BaseSimulation> createState();
}

abstract class BaseSimulationState<T extends BaseSimulation> extends State<T> {
  bool _isLoading = false;
  String? _error;

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void setError(String? error) {
    setState(() {
      _error = error;
    });
  }

  Widget buildSimulationContent();

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setError(null);
                setState(() {});
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return buildSimulationContent();
  }
} 