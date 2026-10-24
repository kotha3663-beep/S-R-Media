import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

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
  String _story = 'আপনি একটি দ্বীপে আটকে পড়েছেন। সামনে একটি ঝোপ এবং একটি গুহা দেখা যাচ্ছে। আপনি কী করবেন?';
  bool _isGameOver = false;

  void _makeChoice(int choice) {
    setState(() {
      if (choice == 1) {
        water -= 10;
        food += 20;
        _story = 'আপনি ঝোপ থেকে কিছু ফল সংগ্রহ করেছেন। (+২০ খাবার)';
      } else if (choice == 2) {
        water += 20;
        health -= 10;
        _story = 'গুহায় একটি পানির ঝর্ণা পেয়েছেন কিন্তু পথে হোঁচট খেয়েছেন। (+২০ পানি, -১০ স্বাস্থ্য)';
      } else if (choice == 3) {
        water -= 30;
        food -= 30;
        health += 20;
        _story = 'আপনি বিশ্রাম নিয়েছেন এবং ঘুমিয়েছেন। (-৩০ খাবার, -৩০ পানি, +২০ স্বাস্থ্য)';
      }

      day++;
      if (water < 0) water = 0;
      if (food < 0) food = 0;
      if (health < 0) health = 0;

      if (water == 0 || food == 0 || health == 0) {
        _isGameOver = true;
        _story = 'আপনি আর বাঁচলেন না। আপনি $_day দিন টিকে ছিলেন।';
      } else {
        _story = '$_story\n\nদিন $day শুরু হলো। আপনি কী করবেন?';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Survival')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('পানি', water, Colors.blue),
                _buildStat('খাবার', food, Colors.orange),
                _buildStat('স্বাস্থ্য', health, Colors.red),
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
                child: const Text('ফল খুঁজুন'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _makeChoice(2),
                child: const Text('পানি খুঁজুন'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _makeChoice(3),
                child: const Text('বিশ্রাম নিন'),
              ),
            ] else 
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    water = 100;
                    food = 100;
                    health = 100;
                    day = 1;
                    _isGameOver = false;
                    _story = 'আপনি একটি দ্বীপে আটকে পড়েছেন। সামনে একটি ঝোপ এবং একটি গুহা দেখা যাচ্ছে। আপনি কী করবেন?';
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, foregroundColor: Colors.white),
                child: const Text('আবার শুরু করুন'),
              ),
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
