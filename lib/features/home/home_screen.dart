import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/language_service.dart';
import '../settings/screens/settings_screen.dart';
import '../quiz/screens/quiz_setup_screen.dart';
import '../knowledge/screens/knowledge_screen.dart';

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
                      onTap: () {},
                    ),
                    _buildCategoryCard(
                      title: isBn ? 'মিনি গেমস' : 'Mini Games',
                      icon: Icons.sports_esports_outlined,
                      color: AppColors.gamesAccent,
                      onTap: () {},
                    ),
                    _buildCategoryCard(
                      title: isBn ? 'স্বাস্থ্য টিপস' : 'Health Tips',
                      icon: Icons.favorite_border,
                      color: AppColors.healthAccent,
                      onTap: () {},
                    ),
                    _buildCategoryCard(
                      title: isBn ? 'জ্ঞান ও কুইজ' : 'Knowledge & Quiz',
                      icon: Icons.lightbulb_outline,
                      color: AppColors.knowledgeAccent,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isBn ? 'আজকের তথ্য' : 'Daily Info', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const KnowledgeScreen()));
                      }, 
                      child: Text(isBn ? 'সব দেখুন' : 'See All', style: const TextStyle(color: AppColors.secondary))
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.knowledgeAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.knowledgeAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isBn ? 'বাংলাদেশের জাতীয় ফুল কোনটি?' : 'What is the national flower of Bangladesh?',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isBn 
                          ? 'বাংলাদেশের জাতীয় ফুল হলো শাপলা (Nymphaea nouchali)। এটি ১৯৭১ সালে স্বাধীনতার পর জাতীয় ফুল হিসেবে ঘোষণা করা হয়...'
                          : 'The national flower of Bangladesh is the Water Lily (Nymphaea nouchali). It was declared as the national flower after independence in 1971...',
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const KnowledgeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.knowledgeAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(isBn ? 'বিস্তারিত পড়ুন' : 'Read More', style: const TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, Color(0xFF2563EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isBn ? 'আজকের কুইজ চ্যালেঞ্জ' : 'Daily Quiz Challenge',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isBn ? 'সঠিকতা এবং দ্রুততার উপর নিজেকে যাচাই করুন।' : 'Test yourself on accuracy and speed.',
                              style: const TextStyle(fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizSetupScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(isBn ? 'শুরু করুন' : 'Start', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
