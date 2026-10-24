import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class RunnerGame extends StatefulWidget {
  const RunnerGame({super.key});

  @override
  State<RunnerGame> createState() => _RunnerGameState();
}

class _RunnerGameState extends State<RunnerGame> {
  double playerY = 0;
  double velocity = 0;
  List<Offset> obstacles = [];
  Timer? _timer;
  int score = 0;
  bool isGameOver = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    playerY = 0;
    velocity = 0;
    obstacles.clear();
    score = 0;
    isGameOver = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (isGameOver) return;
      setState(() {
        score++;
        velocity += 0.05;
        playerY += velocity;

        if (playerY > 1.0) {
          playerY = 1.0;
          velocity = 0;
        }

        for (var i = obstacles.length - 1; i >= 0; i--) {
          obstacles[i] = Offset(obstacles[i].dx - 0.02, obstacles[i].dy);
          if (obstacles[i].dx < 0) {
            obstacles.removeAt(i);
          } else if (obstacles[i].dx < 0.2 && obstacles[i].dx > 0.1 && playerY > 0.7) {
            isGameOver = true;
            _timer?.cancel();
          }
        }

        if (_random.nextDouble() > 0.95) {
          obstacles.add(const Offset(1.2, 1.0));
        }
      });
    });
  }

  void _jump() {
    if (playerY >= 0.95) {
      velocity = -1.0;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2D Runner')),
      body: GestureDetector(
        onTap: _jump,
        child: Container(
          color: const Color(0xFF1A1A1A),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: Text('স্কোর: $score', style: const TextStyle(color: Colors.white, fontSize: 20)),
              ),
              Positioned(
                left: 50,
                top: MediaQuery.of(context).size.height * 0.7 - (playerY * 100),
                child: Container(width: 40, height: 40, color: Colors.green),
              ),
              ...obstacles.map((o) => Positioned(
                left: o.dx * MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height * 0.7,
                child: Container(width: 30, height: 30, color: Colors.red),
              )),
              if (isGameOver)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('গেম ওভার!', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: _startGame, child: const Text('আবার শুরু করুন')),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
