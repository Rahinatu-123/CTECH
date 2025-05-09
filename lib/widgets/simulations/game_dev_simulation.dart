import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'base_simulation.dart';

class GameDevSimulation extends BaseSimulation {
  const GameDevSimulation({Key? key}) : super(key: key);

  @override
  State<GameDevSimulation> createState() => _GameDevSimulationState();
}

class _GameDevSimulationState extends BaseSimulationState<GameDevSimulation> {
  static const double playerSize = 40.0;
  static const double platformHeight = 20.0;
  static const double gravity = 0.5;
  static const double jumpForce = -12.0;
  static const double moveSpeed = 5.0;

  double _playerX = 0.0;
  double _playerY = 0.0;
  double _playerVelocityY = 0.0;
  bool _isJumping = false;
  bool _isMovingLeft = false;
  bool _isMovingRight = false;
  int _score = 0;
  bool _isGameOver = false;
  Timer? _gameTimer;
  final Random _random = Random();

  List<Map<String, dynamic>> _platforms = [];
  List<Map<String, dynamic>> _coins = [];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _playerX = 0.0;
      _playerY = 0.0;
      _playerVelocityY = 0.0;
      _score = 0;
      _isGameOver = false;
      _platforms = [];
      _coins = [];
    });

    // Generate initial platforms
    for (int i = 0; i < 5; i++) {
      _addPlatform();
    }

    // Start game loop
    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _updateGame();
    });
  }

  void _addPlatform() {
    final lastPlatform = _platforms.isEmpty ? null : _platforms.last;
    final x = lastPlatform == null ? 0.0 : lastPlatform['x'] + 200.0 + _random.nextDouble() * 100.0;
    final y = lastPlatform == null ? 300.0 : lastPlatform['y'] + (_random.nextDouble() * 100.0 - 50.0);
    
    _platforms.add({
      'x': x,
      'y': y,
      'width': 100.0 + _random.nextDouble() * 100.0,
    });

    // Add coin above platform
    _coins.add({
      'x': x + 50.0,
      'y': y - 50.0,
      'collected': false,
    });
  }

  void _updateGame() {
    if (_isGameOver) return;

    setState(() {
      // Apply gravity
      _playerVelocityY += gravity;
      _playerY += _playerVelocityY;

      // Apply horizontal movement
      if (_isMovingLeft) _playerX -= moveSpeed;
      if (_isMovingRight) _playerX += moveSpeed;

      // Check platform collisions
      bool onPlatform = false;
      for (var platform in _platforms) {
        if (_playerX + playerSize > platform['x'] &&
            _playerX < platform['x'] + platform['width'] &&
            _playerY + playerSize > platform['y'] &&
            _playerY + playerSize < platform['y'] + platformHeight) {
          _playerY = platform['y'] - playerSize;
          _playerVelocityY = 0.0;
          _isJumping = false;
          onPlatform = true;
          break;
        }
      }

      // Check coin collisions
      for (var coin in _coins) {
        if (!coin['collected'] &&
            _playerX + playerSize > coin['x'] &&
            _playerX < coin['x'] + 20.0 &&
            _playerY + playerSize > coin['y'] &&
            _playerY < coin['y'] + 20.0) {
          coin['collected'] = true;
          _score += 10;
        }
      }

      // Add new platforms as player moves right
      if (_platforms.last['x'] + _platforms.last['width'] < _playerX + 500) {
        _addPlatform();
      }

      // Remove old platforms
      _platforms.removeWhere((platform) => platform['x'] + platform['width'] < _playerX - 100);
      _coins.removeWhere((coin) => coin['x'] < _playerX - 100);

      // Check game over
      if (_playerY > 600) {
        _isGameOver = true;
        _gameTimer?.cancel();
      }
    });
  }

  void _jump() {
    if (!_isJumping) {
      setState(() {
        _playerVelocityY = jumpForce;
        _isJumping = true;
      });
    }
  }

  @override
  Widget buildSimulationContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Score: $_score',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_isGameOver)
                ElevatedButton(
                  onPressed: _startGame,
                  child: const Text('Restart Game'),
                ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx < 0) {
                _isMovingLeft = true;
                _isMovingRight = false;
              } else if (details.delta.dx > 0) {
                _isMovingLeft = false;
                _isMovingRight = true;
              }
            },
            onPanEnd: (_) {
              _isMovingLeft = false;
              _isMovingRight = false;
            },
            onTap: _jump,
            child: Container(
              color: Colors.lightBlue[100],
              child: Stack(
                children: [
                  // Platforms
                  ..._platforms.map((platform) => Positioned(
                        left: platform['x'] - _playerX + 200,
                        top: platform['y'],
                        child: Container(
                          width: platform['width'],
                          height: platformHeight,
                          color: Colors.brown,
                        ),
                      )),
                  // Coins
                  ..._coins.where((coin) => !coin['collected']).map((coin) => Positioned(
                        left: coin['x'] - _playerX + 200,
                        top: coin['y'],
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )),
                  // Player
                  Positioned(
                    left: 200,
                    top: _playerY,
                    child: Container(
                      width: playerSize,
                      height: playerSize,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onPanStart: (_) {
                  _isMovingLeft = true;
                  _isMovingRight = false;
                },
                onPanEnd: (_) {
                  _isMovingLeft = false;
                },
                child: ElevatedButton(
                  onPressed: () {
                    _isMovingLeft = true;
                    _isMovingRight = false;
                  },
                  child: const Text('Left'),
                ),
              ),
              ElevatedButton(
                onPressed: _jump,
                child: const Text('Jump'),
              ),
              GestureDetector(
                onPanStart: (_) {
                  _isMovingLeft = false;
                  _isMovingRight = true;
                },
                onPanEnd: (_) {
                  _isMovingRight = false;
                },
                child: ElevatedButton(
                  onPressed: () {
                    _isMovingLeft = false;
                    _isMovingRight = true;
                  },
                  child: const Text('Right'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 