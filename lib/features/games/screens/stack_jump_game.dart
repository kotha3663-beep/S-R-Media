import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

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
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startGame();
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
      appBar: AppBar(title: const Text('Stack & Jump')),
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
