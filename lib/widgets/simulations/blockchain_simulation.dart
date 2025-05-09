import 'package:flutter/material.dart';
import 'dart:math';
import 'base_simulation.dart';

class BlockchainSimulation extends BaseSimulation {
  const BlockchainSimulation({Key? key}) : super(key: key);

  @override
  State<BlockchainSimulation> createState() => _BlockchainSimulationState();
}

class _BlockchainSimulationState extends BaseSimulationState<BlockchainSimulation> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  double _balance = 1000.0;
  List<Map<String, dynamic>> _transactions = [];
  bool _isProcessing = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _addSampleTransactions();
  }

  void _addSampleTransactions() {
    _transactions = [
      {
        'type': 'deploy',
        'from': 'System',
        'to': 'Smart Contract',
        'amount': 0.0,
        'status': 'success',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
        'hash': _generateHash(),
      },
      {
        'type': 'transfer',
        'from': 'Alice',
        'to': 'Bob',
        'amount': 50.0,
        'status': 'success',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'hash': _generateHash(),
      },
    ];
  }

  String _generateHash() {
    const chars = '0123456789abcdef';
    return List.generate(64, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  Future<void> _processTransaction() async {
    if (_amountController.text.isEmpty || _recipientController.text.isEmpty) {
      setError('Please fill in all fields');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setError('Invalid amount');
      return;
    }

    if (amount > _balance) {
      setError('Insufficient balance');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate blockchain transaction processing
    await Future.delayed(const Duration(seconds: 2));

    final success = _random.nextBool();
    if (success) {
      setState(() {
        _balance -= amount;
        _transactions.insert(0, {
          'type': 'transfer',
          'from': 'You',
          'to': _recipientController.text,
          'amount': amount,
          'status': 'success',
          'timestamp': DateTime.now(),
          'hash': _generateHash(),
        });
      });
    } else {
      setError('Transaction failed. Please try again.');
    }

    setState(() {
      _isProcessing = false;
      _amountController.clear();
      _recipientController.clear();
    });
  }

  @override
  String getInstructions() {
    return 'Create and interact with a simple blockchain. Learn about blocks, transactions, and the principles of decentralized systems.';
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
            'Blockchain Simulator',
            style: TextStyle(
              fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenSize.height * 0.01),
          Card(
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Transaction',
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.03 : screenSize.width * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.005),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.02,
                        vertical: screenSize.height * 0.01,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015),
                  ),
                  SizedBox(height: screenSize.height * 0.005),
                  TextField(
                    controller: _recipientController,
                    decoration: InputDecoration(
                      labelText: 'Recipient',
                      labelStyle: TextStyle(fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.02,
                        vertical: screenSize.height * 0.01,
                      ),
                    ),
                    style: TextStyle(fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015),
                  ),
                  SizedBox(height: screenSize.height * 0.005),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _processTransaction,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.02,
                        vertical: screenSize.height * 0.01,
                      ),
                    ),
                    child: Text(
                      _isProcessing ? 'Processing...' : 'Send Transaction',
                      style: TextStyle(
                        fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                      'Transaction History',
                      style: TextStyle(
                        fontSize: isSmallScreen ? screenSize.width * 0.03 : screenSize.width * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.005),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final tx = _transactions[index];
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
                                        tx['type'] == 'transfer'
                                            ? Icons.send
                                            : Icons.code,
                                        size: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                                        color: tx['status'] == 'success'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      SizedBox(width: screenSize.width * 0.01),
                                      Expanded(
                                        child: Text(
                                          '${tx['from']} → ${tx['to']}',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        tx['amount'] > 0
                                            ? '${tx['amount']} ETH'
                                            : '',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenSize.height * 0.002),
                                  Text(
                                    'Hash: ${tx['hash']}',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? screenSize.width * 0.02 : screenSize.width * 0.015,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Time: ${_formatTimestamp(tx['timestamp'])}',
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

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
} 