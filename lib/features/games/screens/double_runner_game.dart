import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class DoubleRunnerGame extends StatefulWidget {
  const DoubleRunnerGame({super.key});

  @override
  State<DoubleRunnerGame> createState() => _DoubleRunnerGameState();
}

class _DoubleRunnerGameState extends State<DoubleRunnerGame> {
  double topPlayerY = 0;
  double topVelocity = 0;
  double bottomPlayerY = 0;
  double bottomVelocity = 0;
  
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
    topPlayerY = 0;
    topVelocity = 0;
    bottomPlayerY = 0;
    bottomVelocity = 0;
    obstacles.clear();
    score = 0;
    isGameOver = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (isGameOver) return;
      setState(() {
        score++;
        topVelocity += 0.05;
        topPlayerY += topVelocity;
        if (topPlayerY > 1.0) { topPlayerY = 1.0; topVelocity = 0; }

        bottomVelocity += 0.05;
        bottomPlayerY += bottomVelocity;
        if (bottomPlayerY > 1.0) { bottomPlayerY = 1.0; bottomVelocity = 0; }

        for (var i = obstacles.length - 1; i >= 0; i--) {
          obstacles[i] = Offset(obstacles[i].dx - 0.02, obstacles[i].dy);
          if (obstacles[i].dx < 0) {
            obstacles.removeAt(i);
          } else if (obstacles[i].dx < 0.2 && obstacles[i].dx > 0.1) {
            if (obstacles[i].dy == 0 && topPlayerY > 0.7) isGameOver = true;
            if (obstacles[i].dy == 1 && bottomPlayerY > 0.7) isGameOver = true;
            if (isGameOver) _timer?.cancel();
          }
        }

        if (_random.nextDouble() > 0.95) {
          obstacles.add(Offset(1.2, _random.nextBool() ? 0.0 : 1.0));
        }
      });
    });
  }

  void _jumpTop() { if (topPlayerY >= 0.95) topVelocity = -1.0; }
  void _jumpBottom() { if (bottomPlayerY >= 0.95) bottomVelocity = -1.0; }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Double Runner')),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _jumpTop,
              child: Container(
                color: const Color(0xFF1A1A1A),
                child: Stack(
                  children: [
                    Positioned(
                      left: 50,
                      top: height * 0.3 - (topPlayerY * 100),
                      child: Container(width: 40, height: 40, color: Colors.green),
                    ),
                    ...obstacles.where((o) => o.dy == 0).map((o) => Positioned(
                      left: o.dx * MediaQuery.of(context).size.width,
                      top: height * 0.3,
                      child: Container(width: 30, height: 30, color: Colors.red),
                    )),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 4, thickness: 4, color: Colors.white),
          Expanded(
            child: GestureDetector(
              onTap: _jumpBottom,
              child: Container(
                color: const Color(0xFF222222),
                child: Stack(
                  children: [
                    Positioned(
                      left: 50,
                      top: height * 0.3 - (bottomPlayerY * 100),
                      child: Container(width: 40, height: 40, color: Colors.blue),
                    ),
                    ...obstacles.where((o) => o.dy == 1).map((o) => Positioned(
                      left: o.dx * MediaQuery.of(context).size.width,
                      top: height * 0.3,
                      child: Container(width: 30, height: 30, color: Colors.red),
                    )),
                  ],
                ),
              ),
            ),
          ),
          if (isGameOver)
            Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('গেম ওভার! স্কোর: $score', style: const TextStyle(color: Colors.white, fontSize: 20)),
                  ElevatedButton(onPressed: _startGame, child: const Text('আবার শুরু করুন')),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
