import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GameDevSimulation extends StatefulWidget {
  const GameDevSimulation({Key? key}) : super(key: key);

  @override
  _GameDevSimulationState createState() => _GameDevSimulationState();
}

class _GameDevSimulationState extends State<GameDevSimulation> {
  double playerX = 0;
  double playerY = 0;
  bool isJumping = false;
  int score = 0;
  Timer? gameTimer;
  List<Map<String, double>> platforms = [];
  List<Map<String, double>> coins = [];
  bool isGameRunning = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    playerX = 0;
    playerY = 0;
    score = 0;
    platforms = [
      {'x': 0, 'y': 0.8, 'width': 0.3},
      {'x': 0.4, 'y': 0.6, 'width': 0.3},
      {'x': 0.8, 'y': 0.4, 'width': 0.3},
    ];
    coins = [
      {'x': 0.2, 'y': 0.7},
      {'x': 0.6, 'y': 0.5},
      {'x': 0.9, 'y': 0.3},
    ];
  }

  void _startGame() {
    setState(() {
      isGameRunning = true;
    });
    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _updateGame();
    });
  }

  void _updateGame() {
    if (!isGameRunning) return;

    setState(() {
      // Apply gravity
      if (!isJumping) {
        playerY += 0.02;
      }

      // Check platform collisions
      for (var platform in platforms) {
        if (playerX >= platform['x']! &&
            playerX <= platform['x']! + platform['width']! &&
            playerY >= platform['y']! - 0.1 &&
            playerY <= platform['y']!) {
          playerY = platform['y']!;
          isJumping = false;
        }
      }

      // Check coin collisions
      coins.removeWhere((coin) {
        if ((playerX - coin['x']!).abs() < 0.1 &&
            (playerY - coin['y']!).abs() < 0.1) {
          score += 10;
          return true;
        }
        return false;
      });

      // Check if player fell
      if (playerY > 1) {
        _gameOver();
      }
    });
  }

  void _jump() {
    if (!isJumping) {
      setState(() {
        isJumping = true;
        playerY -= 0.2;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            isJumping = false;
          });
        }
      });
    }
  }

  void _moveLeft() {
    if (playerX > 0) {
      setState(() {
        playerX -= 0.1;
      });
    }
  }

  void _moveRight() {
    if (playerX < 0.9) {
      setState(() {
        playerX += 0.1;
      });
    }
  }

  void _gameOver() {
    gameTimer?.cancel();
    setState(() {
      isGameRunning = false;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Score: $score',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0) {
                _moveRight();
              } else {
                _moveLeft();
              }
            },
            onTap: _jump,
            child: Container(
              color: Colors.blue[100],
              child: Stack(
                children: [
                  // Platforms
                  ...platforms.map((platform) => Positioned(
                        left: platform['x']! * MediaQuery.of(context).size.width,
                        top: platform['y']! * MediaQuery.of(context).size.height,
                        child: Container(
                          width: platform['width']! * MediaQuery.of(context).size.width,
                          height: 20,
                          color: Colors.brown,
                        ),
                      )),
                  // Coins
                  ...coins.map((coin) => Positioned(
                        left: coin['x']! * MediaQuery.of(context).size.width,
                        top: coin['y']! * MediaQuery.of(context).size.height,
                        child: const Icon(
                          Icons.monetization_on,
                          color: Colors.yellow,
                          size: 30,
                        ),
                      )),
                  // Player
                  Positioned(
                    left: playerX * MediaQuery.of(context).size.width,
                    top: playerY * MediaQuery.of(context).size.height,
                    child: Container(
                      width: 50,
                      height: 50,
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
        if (!isGameRunning)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _startGame,
              child: const Text('Start Game'),
            ),
          ),
      ],
    );
  }
} 