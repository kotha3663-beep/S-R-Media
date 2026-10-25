import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/language_service.dart';
import '../data/game_repository.dart';
import '../models/game_record_model.dart';

class GameOverScreen extends StatefulWidget {
  final String gameId;
  final String gameName;
  final int score;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const GameOverScreen({
    super.key,
    required this.gameId,
    required this.gameName,
    required this.score,
    required this.onRestart,
    required this.onExit,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  bool _isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _checkAndSaveScore();
  }

  Future<void> _checkAndSaveScore() async {
    final repo = GameRepository();
    final record = await repo.getGameRecord(widget.gameId);

    if (record == null || widget.score > record.highScore) {
      _isNewHighScore = true;
      await repo.saveGameRecord(GameRecordModel(
        gameId: widget.gameId,
        highScore: widget.score,
        lastLevel: 1,
        lastPlayed: DateTime.now(),
      ));
      if (mounted) setState(() {});
    } else {
      await repo.saveGameRecord(GameRecordModel(
        gameId: widget.gameId,
        highScore: record.highScore,
        lastLevel: record.lastLevel,
        lastPlayed: DateTime.now(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = LanguageService().currentLocale.languageCode == 'bn';

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.gameName,
                style: const TextStyle(color: Colors.white70, fontSize: 24),
              ),
              const SizedBox(height: 20),
              Text(
                isBn ? 'গেম ওভার!' : 'Game Over!',
                style: const TextStyle(color: Colors.redAccent, fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                isBn ? 'স্কোর: ${widget.score}' : 'Score: ${widget.score}',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              if (_isNewHighScore) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.gameGold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isBn ? '🎉 নতুন সর্বোচ্চ স্কোর!' : '🎉 New High Score!',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onRestart();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(isBn ? 'আবার খেলুন' : 'Play Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onExit();
                    },
                    icon: const Icon(Icons.exit_to_app),
                    label: Text(isBn ? 'বের হন' : 'Exit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
