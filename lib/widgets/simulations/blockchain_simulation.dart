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
  Widget buildSimulationContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Blockchain Smart Contract Simulator',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Balance Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Your Balance',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_balance.toStringAsFixed(2)} ETH',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Transaction Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Send ETH',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _recipientController,
                    decoration: const InputDecoration(
                      labelText: 'Recipient Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount (ETH)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _processTransaction,
                    child: Text(_isProcessing ? 'Processing...' : 'Send'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Transaction History
          const Text(
            'Transaction History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      tx['type'] == 'deploy' ? Icons.code : Icons.send,
                      color: tx['status'] == 'success' ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      tx['type'] == 'deploy'
                          ? 'Contract Deployed'
                          : '${tx['from']} → ${tx['to']}',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount: ${tx['amount'].toStringAsFixed(2)} ETH',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Hash: ${tx['hash'].substring(0, 8)}...',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      _formatTimestamp(tx['timestamp']),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
} 