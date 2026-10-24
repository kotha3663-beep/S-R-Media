import 'package:flutter/material.dart';

class AppColors {
  // মেইন ব্র্যান্ড কালার (প্রফেশনাল লুকের জন্য)
  static const Color primary = Color(0xFF1E293B); // Deep Slate
  static const Color secondary = Color(0xFF3B82F6); // Modern Blue

  // ৪টি মূল ফিচারের অ্যাকসেন্ট কালার
  static const Color ledgerAccent = Color(0xFF10B981); // সবুজ (হিসাব)
  static const Color gamesAccent = Color(0xFFF59E0B); // কমলা (গেমস)
  static const Color healthAccent = Color(0xFFEF4444); // লাল (স্বাস্থ্য)
  static const Color knowledgeAccent = Color(0xFF8B5CF6); // পার্পল (জ্ঞান ও কুইজ)

  // ব্যাকগ্রাউন্ড ও সারফেস
  static const Color background = Color(0xFFF8FAFC); // হালকা ধূসর-নীল
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE2E8F0);

  // টেক্সট কালার
  static const Color textPrimary = Color(0xFF0F172A); 
  static const Color textSecondary = Color(0xFF64748B); 
  static const Color textLight = Colors.white;

  // অ্যাকশন ও স্টেটাস
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  
  // কুইজ স্পেসিফিক
  static const Color quizCorrect = Color(0xFF10B981);
  static const Color quizWrong = Color(0xFFEF4444);
}
