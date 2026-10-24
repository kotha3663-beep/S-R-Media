import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class GameHubScreen extends StatelessWidget {
  const GameHubScreen({super.key});

  final List<Map<String, dynamic>> games = const [
    {'id': '2048', 'name': '2048 Merge', 'icon': Icons.grid_view},
    {'id': 'water_sort', 'name': 'Water Sort', 'icon': Icons.local_drink},
    {'id': 'dot_connect', 'name': 'Dot Connect', 'icon': Icons.pattern},
    {'id': 'laser', 'name': 'Laser & Mirrors', 'icon': Icons.flare},
    {'id': 'survival', 'name': 'Text Survival', 'icon': Icons.book},
    {'id': 'dot_survivor', 'name': 'Dot Survivor', 'icon': Icons.blur_on},
    {'id': 'tower_defense', 'name': 'Tower Defense', 'icon': Icons.castle},
    {'id': 'runner', 'name': '2D Runner', 'icon': Icons.directions_run},
    {'id': 'double_runner', 'name': 'Double Runner', 'icon': Icons.people},
    {'id': 'stack_jump', 'name': 'Stack & Jump', 'icon': Icons.stacked_bar_chart},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('মিনি গেমস'),
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
            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${game['name']} শীঘ্রই আসছে!')),
                );
              },
              borderRadius: BorderRadius.circular(16),
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
                    Text(
                      game['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
