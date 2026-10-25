import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/navigation/main_navigation_screen.dart';
import 'core/localization/app_localizations.dart';
import 'core/services/language_service.dart';
import 'features/health/data/health_repository.dart';
import 'features/knowledge/data/knowledge_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await LanguageService().init();
    
    // ডেটাবেসে প্রাথমিক ডেটা লোড করা (try-catch দিয়ে যাতে অ্যাপ ক্র্যাশ না করে)
    await HealthRepository().insertInitialTipsIfNeeded();
    await KnowledgeRepository().insertInitialDataIfNeeded();
  } catch (e) {
    debugPrint('Error initializing app: $e');
  }

  runApp(const MyWorkApp());
}

class MyWorkApp extends StatelessWidget {
  const MyWorkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final langService = LanguageService();

    return ListenableBuilder(
      listenable: langService,
      builder: (context, _) {
        return MaterialApp(
          title: 'MyWork',
          debugShowCheckedModeBanner: false,
          locale: langService.currentLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
            primaryColor: AppColors.primary,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              background: AppColors.background,
              error: AppColors.error,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.background,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.textPrimary),
              titleTextStyle: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            cardTheme: const CardTheme(
              color: AppColors.cardBackground,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                side: BorderSide(color: AppColors.divider, width: 1),
              ),
            ),
          ),
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
