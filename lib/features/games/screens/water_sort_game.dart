import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/language_service.dart';
import 'game_over_screen.dart';

class WaterSortGame extends StatefulWidget {
  const WaterSortGame({super.key});

  @override
  State<WaterSortGame> createState() => _WaterSortGameState();
}

class _WaterSortGameState extends State<WaterSortGame> {
  final List<List<Color>> _tubes = [
    [Colors.red, Colors.blue, Colors.green, Colors.yellow],
    [Colors.blue, Colors.green, Colors.yellow, Colors.red],
    [Colors.green, Colors.yellow, Colors.red, Colors.blue],
    [Colors.yellow, Colors.red, Colors.blue, Colors.green],
    [], [],
  ];

  int? _selectedTube;
  final int _capacity = 4;
  int _moves = 0;

  void _handleTubeTap(int index) {
    if (_selectedTube == null) {
      if (_tubes[index].isNotEmpty) {
        setState(() => _selectedTube = index);
      }
    } else {
      if (_selectedTube == index) {
        setState(() => _selectedTube = null);
        return;
      }

      final sourceTube = _tubes[_selectedTube!];
      final targetTube = _tubes[index];

      if (targetTube.length < _capacity) {
        final colorToMove = sourceTube.last;
        
        if (targetTube.isEmpty || targetTube.last == colorToMove) {
          setState(() {
            int count = 0;
            while (sourceTube.isNotEmpty && sourceTube.last == colorToMove && targetTube.length + count < _capacity) {
              targetTube.add(sourceTube.removeLast());
              count++;
            }
            _selectedTube = null;
            _moves++;
          });
          _checkWin();
        } else {
          setState(() => _selectedTube = index);
        }
      } else {
        setState(() => _selectedTube = null);
      }
    }
  }

  void _checkWin() {
    bool isWin = true;
    for (var tube in _tubes) {
      if (tube.isNotEmpty && tube.length != _capacity) {
        isWin = false;
        break;
      }
      if (tube.isNotEmpty) {
        final firstColor = tube.first;
        if (tube.any((c) => c != firstColor)) {
          isWin = false;
          break;
        }
      }
    }

    if (isWin) {
      final isBn = LanguageService().currentLocale.languageCode == 'bn';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameOverScreen(
            gameId: 'water_sort',
            gameName: isBn ? 'ওয়াটার সর্ট' : 'Water Sort',
            score: _moves,
            onRestart: () => _resetGame(),
            onExit: () => Navigator.pop(context),
          ),
        ),
      );
    }
  }

  void _resetGame() {
    setState(() {
      _selectedTube = null;
      _moves = 0;
      _tubes.clear();
      _tubes.addAll([
        [Colors.red, Colors.blue, Colors.green, Colors.yellow],
        [Colors.blue, Colors.green, Colors.yellow, Colors.red],
        [Colors.green, Colors.yellow, Colors.red, Colors.blue],
        [Colors.yellow, Colors.red, Colors.blue, Colors.green],
        [], [],
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBn = LanguageService().currentLocale.languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'ওয়াটার সর্ট' : 'Water Sort'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(isBn ? 'চাল: $_moves' : 'Moves: $_moves', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: List.generate(_tubes.length, (index) {
                  final isSelected = _selectedTube == index;
                  return GestureDetector(
                    onTap: () => _handleTubeTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      height: 220,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? AppColors.secondary : AppColors.textSecondary,
                          width: isSelected ? 4 : 2,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(30),
                          top: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _tubes[index].map((color) {
                          return Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.vertical(
                                bottom: _tubes[index].first == color ? const Radius.circular(28) : Radius.zero,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
