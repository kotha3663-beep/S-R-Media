import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'game_over_screen.dart';
import '../data/game_repository.dart';

class StackJumpGame extends StatefulWidget {
  const StackJumpGame({super.key});

  @override
  State<StackJumpGame> createState() => _StackJumpGameState();
}

class _StackJumpGameState extends State<StackJumpGame> {
  double blockX = 0;
  double velocity = 0.05;
  List<double> stack = [0.5];
  int score = 0;
  bool isGameOver = false;
  Timer? _timer;
  double _bestScore = 0;

  @override
  void initState() {
    super.initState();
    _loadBestScore();
    _startGame();
  }

  Future<void> _loadBestScore() async {
    final repo = GameRepository();
    final record = await repo.getGameRecord('stack_jump');
    if (record != null) {
      setState(() {
        _bestScore = record.highScore.toDouble();
      });
    }
  }

  void _startGame() {
    setState(() {
      blockX = 0;
      velocity = 0.05;
      stack = [0.5];
      score = 0;
      isGameOver = false;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        setState(() {
          blockX += velocity;
          if (blockX > 1.0 || blockX < 0.0) {
            velocity = -velocity;
          }
        });
      });
    });
  }

  void _dropBlock() {
    if (isGameOver) return;
    final lastX = stack.last;
    if ((blockX - lastX).abs() < 0.2) {
      setState(() {
        stack.add(blockX);
        score++;
        blockX = 0;
        velocity = velocity > 0 ? 0.05 + score * 0.005 : -0.05 - score * 0.005;
      });
    } else {
      setState(() {
        isGameOver = true;
        _timer?.cancel();
      });
      _showGameOver();
    }
  }

  void _showGameOver() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          gameId: 'stack_jump',
          gameName: 'Stack & Jump',
          score: score,
          onRestart: _startGame,
          onExit: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stack & Jump'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text('সর্বোচ্চ: ${_bestScore.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: _dropBlock,
        child: Container(
          color: const Color(0xFF1A1A1A),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: Text('স্কোর: $score', style: const TextStyle(color: Colors.white, fontSize: 20)),
              ),
              for (int i = 0; i < stack.length; i++)
                Positioned(
                  bottom: i * 40.0,
                  left: stack[i] * MediaQuery.of(context).size.width - 40,
                  child: Container(
                    width: 80, height: 40, 
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
              Positioned(
                bottom: stack.length * 40.0,
                left: blockX * MediaQuery.of(context).size.width - 40,
                child: Container(
                  width: 80, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
