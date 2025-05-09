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

  String getInstructions();
  Widget buildSimulationContent();

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Simulation',
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.03 : screenSize.width * 0.02,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
                child: Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Text(
                        getInstructions(),
                        style: TextStyle(
                          fontSize: isSmallScreen ? screenSize.width * 0.03 : screenSize.width * 0.02,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Container(
                constraints: BoxConstraints(
                  maxHeight: screenSize.height * 0.6,
                  minHeight: screenSize.height * 0.3,
                ),
                child: buildSimulationContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 