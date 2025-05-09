import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'base_simulation.dart';

class GameDevSimulation extends BaseSimulation {
  const GameDevSimulation({Key? key}) : super(key: key);

  @override
  _GameDevSimulationState createState() => _GameDevSimulationState();
}

class _GameDevSimulationState extends BaseSimulationState<GameDevSimulation> {
  // Game state
  double playerX = 0;
  double playerY = 0;
  double playerVelocityY = 0;
  bool isJumping = false;
  int score = 0;
  bool isGameOver = false;
  Timer? gameTimer;
  List<Platform> platforms = [];
  List<Coin> coins = [];
  Random random = Random();
  bool showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    // Hide controls after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          showControls = false;
        });
      }
    });
  }

  void _initializeGame() {
    playerX = 0;
    playerY = 0;
    playerVelocityY = 0;
    isJumping = false;
    score = 0;
    isGameOver = false;
    platforms.clear();
    coins.clear();

    // Create initial platforms
    platforms.add(Platform(0, 300, 200));
    platforms.add(Platform(250, 250, 150));
    platforms.add(Platform(450, 200, 150));
    platforms.add(Platform(650, 150, 150));

    // Create initial coins
    for (var platform in platforms) {
      coins.add(Coin(platform.x + platform.width / 2, platform.y - 30));
    }

    // Start game loop
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!isGameOver) {
        setState(() {
          _updateGame();
        });
      }
    });
  }

  void _updateGame() {
    // Apply gravity
    playerVelocityY += 0.8;
    playerY += playerVelocityY;

    // Check platform collisions
    for (var platform in platforms) {
      if (playerY + 40 >= platform.y &&
          playerY + 40 <= platform.y + 20 &&
          playerX + 40 >= platform.x &&
          playerX <= platform.x + platform.width) {
        playerY = platform.y - 40;
        playerVelocityY = 0;
        isJumping = false;
      }
    }

    // Check coin collisions
    coins.removeWhere((coin) {
      if ((playerX - coin.x).abs() < 30 && (playerY - coin.y).abs() < 30) {
        score += 10;
        return true;
      }
      return false;
    });

    // Check if player fell off
    if (playerY > 500) {
      isGameOver = true;
      gameTimer?.cancel();
    }

    // Move platforms and coins
    for (var platform in platforms) {
      platform.x -= 2;
    }
    for (var coin in coins) {
      coin.x -= 2;
    }

    // Remove off-screen platforms and add new ones
    platforms.removeWhere((platform) => platform.x + platform.width < 0);
    if (platforms.isEmpty || platforms.last.x < 400) {
      double lastX = platforms.isEmpty ? 0 : platforms.last.x + platforms.last.width;
      platforms.add(Platform(lastX + random.nextDouble() * 100 + 50,
          200 + random.nextDouble() * 100, 150));
      coins.add(Coin(lastX + 75, 170 + random.nextDouble() * 100));
    }
  }

  void _jump() {
    if (!isJumping) {
      playerVelocityY = -15;
      isJumping = true;
    }
  }

  @override
  Widget buildSimulationContent() {
    return GestureDetector(
      onTapDown: (_) => _jump(),
      child: Stack(
        children: [
          // Background
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF87CEEB), Color(0xFFE0F7FA)],
              ),
            ),
          ),
          // Ground
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          // Platforms
          ...platforms.map((platform) => Positioned(
                left: platform.x,
                top: platform.y,
                child: Container(
                  width: platform.width,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF795548),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              )),
          // Coins
          ...coins.map((coin) => Positioned(
                left: coin.x,
                top: coin.y,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '\$',
                      style: TextStyle(
                        color: Color(0xFFB8860B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
          // Player
          Positioned(
            left: playerX,
            top: playerY,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Eyes
                  Positioned(
                    left: 10,
                    top: 12,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 12,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Smile
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Score
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Controls Overlay
          if (showControls)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'How to Play',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Tap anywhere to jump\n• Collect coins for points\n• Don\'t fall off the platforms!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Game Over
          if (isGameOver)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Game Over!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Final Score: $score',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _initializeGame,
                      child: const Text('Play Again'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  String getInstructions() {
    return 'Tap the screen to make the character jump. Collect coins and avoid falling off the platforms!';
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }
}

class Platform {
  double x;
  final double y;
  final double width;

  Platform(this.x, this.y, this.width);
}

class Coin {
  double x;
  final double y;

  Coin(this.x, this.y);
} 