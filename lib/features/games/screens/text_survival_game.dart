import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/language_service.dart';
import 'game_over_screen.dart';

class TextSurvivalGame extends StatefulWidget {
  const TextSurvivalGame({super.key});

  @override
  State<TextSurvivalGame> createState() => _TextSurvivalGameState();
}

class _TextSurvivalGameState extends State<TextSurvivalGame> {
  int water = 100;
  int food = 100;
  int health = 100;
  int day = 1;
  String _story = '';
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      water = 100;
      food = 100;
      health = 100;
      day = 1;
      _isGameOver = false;
      final isBn = LanguageService().currentLocale.languageCode == 'bn';
      _story = isBn 
          ? 'আপনি একটি দ্বীপে আটকে পড়েছেন। সামনে একটি ঝোপ এবং একটি গুহা দেখা যাচ্ছে। আপনি কী করবেন?'
          : 'You are stranded on an island. There is a bush and a cave ahead. What will you do?';
    });
  }

  void _makeChoice(int choice) {
    if (_isGameOver) return;
    
    final isBn = LanguageService().currentLocale.languageCode == 'bn';
    setState(() {
      if (choice == 1) {
        water -= 10;
        food += 20;
        _story = isBn 
            ? 'আপনি ঝোপ থেকে কিছু ফল সংগ্রহ করেছেন। (+২০ খাবার)' 
            : 'You gathered some fruits from the bush. (+20 Food)';
      } else if (choice == 2) {
        water += 20;
        health -= 10;
        _story = isBn 
            ? 'গুহায় একটি পানির ঝর্ণা পেয়েছেন কিন্তু পথে হোঁচট খেয়েছেন। (+২০ পানি, -১০ স্বাস্থ্য)' 
            : 'You found a water spring in the cave but tripped on the way. (+20 Water, -10 Health)';
      } else if (choice == 3) {
        water -= 30;
        food -= 30;
        health += 20;
        _story = isBn 
            ? 'আপনি বিশ্রাম নিয়েছেন এবং ঘুমিয়েছেন। (-৩০ খাবার, -৩০ পানি, +২০ স্বাস্থ্য)' 
            : 'You rested and slept. (-30 Food, -30 Water, +20 Health)';
      }

      day++;
      if (water < 0) water = 0;
      if (food < 0) food = 0;
      if (health < 0) health = 0;

      if (water == 0 || food == 0 || health == 0) {
        _isGameOver = true;
        _story = isBn 
            ? 'আপনি আর বাঁচলেন না। আপনি $day দিন টিকে ছিলেন।' 
            : 'You did not survive. You survived for $day days.';
        _showGameOver();
      } else {
        _story = isBn 
            ? '$_story\n\nদিন $day শুরু হলো। আপনি কী করবেন?' 
            : '$_story\n\nDay $day started. What will you do?';
      }
    });
  }

  void _showGameOver() {
    final isBn = LanguageService().currentLocale.languageCode == 'bn';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          gameId: 'text_survival',
          gameName: isBn ? 'টেক্সট সারভাইভাল' : 'Text Survival',
          score: day,
          onRestart: _resetGame,
          onExit: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBn = LanguageService().currentLocale.languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(title: Text(isBn ? 'টেক্সট সারভাইভাল' : 'Text Survival')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(isBn ? 'পানি' : 'Water', water, Colors.blue),
                _buildStat(isBn ? 'খাবার' : 'Food', food, Colors.orange),
                _buildStat(isBn ? 'স্বাস্থ্য' : 'Health', health, Colors.red),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Center(
                  child: Text(
                    _story,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, height: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!_isGameOver) ...[
              ElevatedButton(
                onPressed: () => _makeChoice(1),
                child: Text(isBn ? 'ফল খুঁজুন' : 'Search for food'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _makeChoice(2),
                child: Text(isBn ? 'পানি খুঁজুন' : 'Search for water'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _makeChoice(3),
                child: Text(isBn ? 'বিশ্রাম নিন' : 'Rest'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('$value', style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
