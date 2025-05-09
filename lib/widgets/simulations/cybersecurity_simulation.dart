import 'package:flutter/material.dart';
import 'dart:math';
import 'base_simulation.dart';

class CybersecuritySimulation extends BaseSimulation {
  const CybersecuritySimulation({Key? key}) : super(key: key);

  @override
  State<CybersecuritySimulation> createState() => _CybersecuritySimulationState();
}

class _CybersecuritySimulationState extends BaseSimulationState<CybersecuritySimulation> {
  final _passwordController = TextEditingController();
  String _strength = '';
  Color _strengthColor = Colors.grey;
  double _entropy = 0.0;
  String _crackTime = '';
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_analyzePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _analyzePassword() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() {
        _strength = 'Enter a password';
        _strengthColor = Colors.grey;
        _entropy = 0.0;
        _crackTime = '';
      });
      return;
    }

    // Calculate password entropy
    final charset = _getCharset(password);
    final length = password.length;
    _entropy = length * log(charset) / log(2);

    // Determine strength and color
    if (_entropy < 30) {
      _strength = 'Very Weak';
      _strengthColor = Colors.red;
    } else if (_entropy < 50) {
      _strength = 'Weak';
      _strengthColor = Colors.orange;
    } else if (_entropy < 70) {
      _strength = 'Moderate';
      _strengthColor = Colors.yellow;
    } else if (_entropy < 100) {
      _strength = 'Strong';
      _strengthColor = Colors.lightGreen;
    } else {
      _strength = 'Very Strong';
      _strengthColor = Colors.green;
    }

    // Estimate crack time
    _crackTime = _estimateCrackTime(_entropy);

    setState(() {});
  }

  double _getCharset(String password) {
    double charset = 0;
    if (password.contains(RegExp(r'[a-z]'))) charset += 26;
    if (password.contains(RegExp(r'[A-Z]'))) charset += 26;
    if (password.contains(RegExp(r'[0-9]'))) charset += 10;
    if (password.contains(RegExp(r'[^a-zA-Z0-9]'))) charset += 33;
    return charset;
  }

  String _estimateCrackTime(double entropy) {
    // Rough estimate based on entropy
    if (entropy < 30) return 'Instantly';
    if (entropy < 50) return 'Minutes to hours';
    if (entropy < 70) return 'Days to weeks';
    if (entropy < 100) return 'Months to years';
    return 'Centuries';
  }

  @override
  String getInstructions() {
    return 'Practice identifying and fixing security vulnerabilities in code. Learn about common security threats and how to protect against them.';
  }

  @override
  Widget buildSimulationContent() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Password Strength Analyzer',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Password',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          size: 16,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    style: const TextStyle(fontSize: 9),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Strength',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _strength,
                              style: TextStyle(
                                fontSize: 9,
                                color: _strengthColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Entropy',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _entropy.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Crack Time',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _crackTime,
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _entropy / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                    minHeight: 4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password Requirements',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildRequirement(
                    'At least 8 characters',
                    _passwordController.text.length >= 8,
                  ),
                  _buildRequirement(
                    'Contains uppercase letter',
                    _passwordController.text.contains(RegExp(r'[A-Z]')),
                  ),
                  _buildRequirement(
                    'Contains lowercase letter',
                    _passwordController.text.contains(RegExp(r'[a-z]')),
                  ),
                  _buildRequirement(
                    'Contains number',
                    _passwordController.text.contains(RegExp(r'[0-9]')),
                  ),
                  _buildRequirement(
                    'Contains special character',
                    _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle,
            size: 12,
            color: isMet ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 8,
              color: isMet ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
} 