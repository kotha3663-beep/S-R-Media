import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/preferences_service.dart';

class GameHubScreen extends StatefulWidget {
  const GameHubScreen({super.key});

  @override
  State<GameHubScreen> createState() => _GameHubScreenState();
}

class _GameHubScreenState extends State<GameHubScreen> {
  String _lang = 'bn';

  final List<Map<String, dynamic>> games = const [
    {'id': '2048', 'name_bn': '২০৪৮', 'name_en': '2048 Merge', 'icon': Icons.grid_view},
    {'id': 'water_sort', 'name_bn': 'ওয়াটার সর্ট', 'name_en': 'Water Sort', 'icon': Icons.local_drink},
    {'id': 'dot_connect', 'name_bn': 'ডট কানেক্ট', 'name_en': 'Dot Connect', 'icon': Icons.pattern},
    {'id': 'laser', 'name_bn': 'লেজার ও মিরর', 'name_en': 'Laser & Mirrors', 'icon': Icons.flare},
    {'id': 'survival', 'name_bn': 'টেক্সট সারভাইভাল', 'name_en': 'Text Survival', 'icon': Icons.book},
    {'id': 'dot_survivor', 'name_bn': 'ডট সারভাইভার', 'name_en': 'Dot Survivor', 'icon': Icons.blur_on},
    {'id': 'tower_defense', 'name_bn': 'টাওয়ার ডিফেন্স', 'name_en': 'Tower Defense', 'icon': Icons.castle},
    {'id': 'runner', 'name_bn': '২ডি রানার', 'name_en': '2D Runner', 'icon': Icons.directions_run},
    {'id': 'double_runner', 'name_bn': 'ডাবল রানার', 'name_en': 'Double Runner', 'icon': Icons.people},
    {'id': 'stack_jump', 'name_bn': 'স্ট্যাক জাম্প', 'name_en': 'Stack & Jump', 'icon': Icons.stacked_bar_chart},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await PreferencesService.getLanguage();
    if (mounted) {
      setState(() {
        _lang = lang;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = _lang == 'bn';

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
            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isBn ? '$name শীঘ্রই আসছে!' : '$name coming soon!')),
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
