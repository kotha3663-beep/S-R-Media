import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/language_service.dart';
import '../settings/screens/settings_screen.dart';
import '../quiz/screens/quiz_setup_screen.dart';
import '../knowledge/screens/knowledge_screen.dart';
import '../ledger/screens/ledger_screen.dart';
import '../games/screens/game_hub_screen.dart';
import '../health/screens/health_tips_screen.dart';
import '../../core/navigation/main_navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        final isBn = LanguageService().currentLocale.languageCode == 'bn';
        final now = DateTime.now();
        final dateString = "${now.day} ${_getMonthName(now.month, isBn)}, ${now.year}";

        return Scaffold(
          appBar: AppBar(
            title: const Text('MyWork', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBn ? 'শুভ দিন!' : 'Good Day!',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  isBn ? 'আজ $dateString' : 'Today is $dateString',
                  style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildCategoryCard(
                      title: isBn ? 'হিসাবের খাতা' : 'Ledger',
                      icon: Icons.account_balance_wallet_outlined,
                      color: AppColors.ledgerAccent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const LedgerScreen()));
                      },
                    ),
                    _buildCategoryCard(
                      title: isBn ? 'মিনি গেমস' : 'Mini Games',
                      icon: Icons.sports_esports_outlined,
                      color: AppColors.gamesAccent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const GameHubScreen()));
                      },
                    ),
                    _buildCategoryCard(
                      title: isBn ? 'স্বাস্থ্য টিপস' : 'Health Tips',
                      icon: Icons.favorite_border,
                      color: AppColors.healthAccent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthTipsScreen()));
                      },
                    ),
                    _buildCategoryCard(
                      title: isBn ? 'জ্ঞান ও কুইজ' : 'Knowledge & Quiz',
                      icon: Icons.lightbulb_outline,
                      color: AppColors.knowledgeAccent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const KnowledgeScreen()));
                      },
                    ),
                  ],
                ),
                // বাকি অংশ আগের মতোই থাকবে (Daily Info, Daily Quiz Challenge)
                // ...
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month, bool isBn) {
    final bnMonths = [
      'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
    ];
    final enMonths = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return isBn ? bnMonths[month - 1] : enMonths[month - 1];
  }
}
