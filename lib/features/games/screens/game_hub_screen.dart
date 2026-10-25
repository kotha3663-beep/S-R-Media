import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/language_service.dart';
import 'water_sort_game.dart';
import 'game_2048.dart';
import 'dot_connect_game.dart';
import 'stack_jump_game.dart';
import 'text_survival_game.dart';
import 'tower_defense_game.dart';

class GameHubScreen extends StatelessWidget {
  const GameHubScreen({super.key});

  final List<Map<String, dynamic>> games = const [
    {'id': '2048', 'name_bn': '২০৪৮', 'name_en': '2048 Merge', 'icon': Icons.grid_view, 'isAvailable': true},
    {'id': 'water_sort', 'name_bn': 'ওয়াটার সর্ট', 'name_en': 'Water Sort', 'icon': Icons.local_drink, 'isAvailable': true},
    {'id': 'dot_connect', 'name_bn': 'ডট কানেক্ট', 'name_en': 'Dot Connect', 'icon': Icons.pattern, 'isAvailable': true},
    {'id': 'stack_jump', 'name_bn': 'স্ট্যাক জাম্প', 'name_en': 'Stack & Jump', 'icon': Icons.stacked_bar_chart, 'isAvailable': true},
    {'id': 'survival', 'name_bn': 'টেক্সট সারভাইভাল', 'name_en': 'Text Survival', 'icon': Icons.book, 'isAvailable': true},
    {'id': 'tower_defense', 'name_bn': 'টাওয়ার ডিফেন্স', 'name_en': 'Tower Defense', 'icon': Icons.castle, 'isAvailable': true},
    {'id': 'laser', 'name_bn': 'লেজার ও মিরর', 'name_en': 'Laser & Mirrors', 'icon': Icons.flare, 'isAvailable': false},
    {'id': 'dot_survivor', 'name_bn': 'ডট সারভাইভার', 'name_en': 'Dot Survivor', 'icon': Icons.blur_on, 'isAvailable': false},
    {'id': 'runner', 'name_bn': '২ডি রানার', 'name_en': '2D Runner', 'icon': Icons.directions_run, 'isAvailable': false},
    {'id': 'double_runner', 'name_bn': 'ডাবল রানার', 'name_en': 'Double Runner', 'icon': Icons.people, 'isAvailable': false},
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        final isBn = LanguageService().currentLocale.languageCode == 'bn';

        return Scaffold(
          appBar: AppBar(
            title: Text(isBn ? 'মিনি গেমস' : 'Mini Games'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                final name = isBn ? game['name_bn'] : game['name_en'];
                final isAvailable = game['isAvailable'] as bool;
                
                return InkWell(
                  onTap: () {
                    if (!isAvailable) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isBn ? '$name শীঘ্রই আসছে!' : '$name coming soon!')),
                      );
                      return;
                    }

                    Widget? screen;
                    switch (game['id']) {
                      case '2048': screen = const Game2048(); break;
                      case 'water_sort': screen = const WaterSortGame(); break;
                      case 'dot_connect': screen = const DotConnectGame(); break;
                      case 'stack_jump': screen = const StackJumpGame(); break;
                      case 'survival': screen = const TextSurvivalGame(); break;
                      case 'tower_defense': screen = const TowerDefenseGame(); break;
                    }

                    if (screen != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Opacity(
                    opacity: isAvailable ? 1.0 : 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.gamesAccent.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(game['icon'], size: 28, color: AppColors.gamesAccent),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (!isAvailable)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Text('শীঘ্রই আসছে', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
