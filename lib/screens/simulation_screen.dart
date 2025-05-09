import 'package:flutter/material.dart';
import '../widgets/simulations/ai_engineer_simulation.dart';
import '../widgets/simulations/data_scientist_simulation.dart';
import '../widgets/simulations/cybersecurity_simulation.dart';
import '../widgets/simulations/mobile_dev_simulation.dart';
import '../widgets/simulations/iot_engineer_simulation.dart';
import '../widgets/simulations/ui_ux_simulation.dart';
import '../widgets/simulations/game_dev_simulation.dart';
import '../widgets/simulations/web_dev_simulation.dart';
import '../widgets/simulations/devops_simulation.dart';
import '../widgets/simulations/blockchain_simulation.dart';

class SimulationScreen extends StatelessWidget {
  final String simulationType;
  final String careerTitle;

  const SimulationScreen({
    Key? key,
    required this.simulationType,
    required this.careerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$careerTitle Simulation'),
        elevation: 0,
      ),
      body: _buildSimulation(),
    );
  }

  Widget _buildSimulation() {
    switch (simulationType) {
      case 'ai_engineer':
        return const AIEngineerSimulation();
      case 'data_scientist':
        return const DataScientistSimulation();
      case 'cybersecurity':
        return const CybersecuritySimulation();
      case 'mobile_dev':
        return const MobileDevSimulation();
      case 'iot_engineer':
        return const IoTEngineerSimulation();
      case 'ui_ux':
        return const UIUXSimulation();
      case 'game_dev':
        return const GameDevSimulation();
      case 'web_dev':
        return const WebDevSimulation();
      case 'devops':
        return const DevOpsSimulation();
      case 'blockchain':
        return const BlockchainSimulation();
      default:
        return const Center(
          child: Text('Simulation not available for this career.'),
        );
    }
  }
} 