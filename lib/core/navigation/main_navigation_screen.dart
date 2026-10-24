import 'package:flutter/material.dart';
import '../../features/home/home_screen.dart';
import '../../features/ledger/screens/ledger_screen.dart';
import '../../features/games/screens/game_hub_screen.dart';
import '../../features/health/screens/health_tips_screen.dart';
import '../../features/knowledge/screens/knowledge_screen.dart';
import '../theme/app_colors.dart';
import '../services/language_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final LanguageService _langService = LanguageService();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _langService,
      builder: (context, _) {
        final isBn = _langService.currentLocale.languageCode == 'bn';

        final List<Widget> screens = [
          HomeScreen(key: ValueKey(isBn)),
          LedgerScreen(key: ValueKey(isBn)),
          GameHubScreen(key: ValueKey(isBn)),
          HealthTipsScreen(key: ValueKey(isBn)),
          KnowledgeScreen(key: ValueKey(isBn)),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.secondary,
            unselectedItemColor: AppColors.textSecondary,
            backgroundColor: Colors.white,
            elevation: 8,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: isBn ? 'হোম' : 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                activeIcon: const Icon(Icons.account_balance_wallet),
                label: isBn ? 'হিসাব' : 'Ledger',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.sports_esports_outlined),
                activeIcon: const Icon(Icons.sports_esports),
                label: isBn ? 'গেমস' : 'Games',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_border),
                activeIcon: const Icon(Icons.favorite),
                label: isBn ? 'স্বাস্থ্য' : 'Health',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.lightbulb_outline),
                activeIcon: const Icon(Icons.lightbulb),
                label: isBn ? 'জ্ঞান' : 'Knowledge',
              ),
            ],
          ),
        );
      },
    );
  }
}
