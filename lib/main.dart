import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() {
  runApp(const MyWorkApp());
}

class MyWorkApp extends StatelessWidget {
  const MyWorkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyWork',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primaryGreen,
        // বাংলা ফন্টের জন্য (পরবর্তীতে গুগল ফন্টস বা লোকাল ফন্ট যুক্ত করা যাবে)
        fontFamily: 'NotoSansBengali', 
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
          error: AppColors.expenseRed,
          background: AppColors.background,
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
      ),
      home: const DashboardScreen(),
    );
  }
}
