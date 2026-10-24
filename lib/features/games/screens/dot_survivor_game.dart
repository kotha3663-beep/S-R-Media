import 'dart:async';
import 'package:flutter/material.dart';

class DotSurvivorGame extends StatefulWidget {
  const DotSurvivorGame({super.key});

  @override
  State<DotSurvivorGame> createState() => _DotSurvivorGameState();
}

class _DotSurvivorGameState extends State<DotSurvivorGame> {
  double playerX = 0;
  double playerY = 0;
  List<Offset> enemies = [];
  Timer? _timer;
  int score = 0;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    playerX = 0;
    playerY = 0;
    enemies = [const Offset(0.5, 0.5), const Offset(-0.5, 0.5)];
    score = 0;
    isGameOver = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (isGameOver) return;
      setState(() {
        score++;
        for (int i = 0; i < enemies.length; i++) {
          final dir = Offset(playerX - enemies[i].dx, playerY - enemies[i].dy);
          final dist = dir.distance;
          if (dist > 0) {
            enemies[i] += Offset(dir.dx / dist, dir.dy / dist) * 0.02;
          }
        }
        for (var enemy in enemies) {
          if ((enemy - Offset(playerX, playerY)).distance < 0.08) {
            isGameOver = true;
            _timer?.cancel();
            break;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dot Survivor')),
      body: GestureDetector(
        onPanUpdate: (details) {
          if (isGameOver) return;
          setState(() {
            playerX += details.delta.dx / 200;
            playerY += details.delta.dy / 200;
          });
        },
        child: Container(
          color: const Color(0xFF1A1A1A),
          child: Stack(
            children: [
              Center(
                child: Text('স্কোর: $score', style: const TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ...enemies.map((e) => _buildDot(e, Colors.red)),
              _buildDot(Offset(playerX, playerY), Colors.green),
              if (isGameOver)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.black87,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('গেম ওভার!', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _startGame,
                          child: const Text('আবার শুরু করুন'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(Offset position, Color color) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 + position.dx * 200 - 10,
      top: MediaQuery.of(context).size.height / 2 + position.dy * 200 - 10,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
