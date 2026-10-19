import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/data_limit_service.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    // Provider দিয়ে সার্ভিসটি পুরো অ্যাপে যুক্ত করা হলো
    ChangeNotifierProvider(
      create: (_) => DataLimitService(),
      child: const HospoApp(),
    ),
  );
}

class HospoApp extends StatelessWidget {
  const HospoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // আপনার আইকনের মতো ডার্ক থিম ও কালার স্কিম
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E676), // গ্রিন
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B132B), // ডার্ক ব্লু
        useMaterial3: true,
        cardTheme: const CardTheme(
          color: Color(0xFF1C2541), // কার্ডের ব্যাকগ্রাউন্ড
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
