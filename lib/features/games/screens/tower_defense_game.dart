import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/language_service.dart';
import 'game_over_screen.dart';

class TowerDefenseGame extends StatefulWidget {
  const TowerDefenseGame({super.key});

  @override
  State<TowerDefenseGame> createState() => _TowerDefenseGameState();
}

class _TowerDefenseGameState extends State<TowerDefenseGame> {
  List<Offset> enemies = [];
  List<Offset> towers = [];
  Timer? _spawnTimer;
  Timer? _moveTimer;
  int health = 100;
  int score = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    setState(() {
      enemies.clear();
      towers.clear();
      health = 100;
      score = 0;
      _isGameOver = false;
      _spawnTimer?.cancel();
      _moveTimer?.cancel();

      _spawnTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (_isGameOver) return;
        setState(() {
          enemies.add(const Offset(0, 0.5));
        });
      });

      _moveTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (_isGameOver) return;
        setState(() {
          for (var i = enemies.length - 1; i >= 0; i--) {
            enemies[i] += const Offset(0.01, 0);
            if (enemies[i].dx > 1.0) {
              enemies.removeAt(i);
              health -= 10;
              if (health <= 0) {
                health = 0;
                _isGameOver = true;
                _showGameOver();
                break;
              }
            } else {
              for (var tower in towers) {
                if ((tower - enemies[i]).distance < 0.1) {
                  enemies.removeAt(i);
                  score += 10;
                  break;
                }
              }
            }
          }
        });
      });
    });
  }

  void _showGameOver() {
    final isBn = LanguageService().currentLocale.languageCode == 'bn';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          gameId: 'tower_defense',
          gameName: isBn ? 'টাওয়ার ডিফেন্স' : 'Tower Defense',
          score: score,
          onRestart: _startGame,
          onExit: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _moveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = LanguageService().currentLocale.languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(title: Text(isBn ? 'টাওয়ার ডিফেন্স' : 'Tower Defense')),
      body: GestureDetector(
        onTapDown: (details) {
          if (_isGameOver) return;
          final box = context.findRenderObject() as RenderBox;
          final localPos = box.globalToLocal(details.globalPosition);
          final size = box.size;
          setState(() {
            towers.add(Offset(localPos.dx / size.width, localPos.dy / size.height));
          });
        },
        child: Container(
          color: const Color(0xFF1A1A1A),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: Text(isBn ? 'স্বাস্থ্য: $health' : 'Health: $health', style: const TextStyle(color: Colors.white, fontSize: 20)),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Text(isBn ? 'স্কোর: $score' : 'Score: $score', style: const TextStyle(color: Colors.white, fontSize: 20)),
              ),
              ...towers.map((t) => Positioned(
                left: t.dx * MediaQuery.of(context).size.width - 15,
                top: t.dy * MediaQuery.of(context).size.height - 15,
                child: Container(
                  width: 30, height: 30, color: Colors.blue,
                ),
              )),
              ...enemies.map((e) => Positioned(
                left: e.dx * MediaQuery.of(context).size.width - 10,
                top: e.dy * MediaQuery.of(context).size.height - 10,
                child: Container(
                  width: 20, height: 20, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
