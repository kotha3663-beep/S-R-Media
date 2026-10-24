import 'package:flutter/material.dart';

class AppColors {
  // ==========================================
  // ১. ব্র্যান্ড ও প্রাইমারি কালার (স্ক্রিনশটের মতো)
  // ==========================================
  static const Color primaryGreen = Color(0xFF2E7D32); // মূল সবুজ (ব্যালেন্স কার্ড, আয় বাটন)
  static const Color primaryGreenDark = Color(0xFF1B5E20); // গাঢ় সবুজ (গ্রেডিয়েন্ট)
  static const Color primaryGreenLight = Color(0xFF4CAF50); // হালকা সবুজ

  // ==========================================
  // ২. অ্যাকশন ও স্টেটাস কালার (সেমান্টিক)
  // ==========================================
  static const Color expenseRed = Color(0xFFD32F2F); // খরচ, ভুল, ডিলিট
  static const Color success = Color(0xFF388E3C); // সফলতা, সঠিক উত্তর
  static const Color warning = Color(0xFFF57C00); // সতর্কতা, পেন্ডিং
  static const Color info = Color(0xFF1976D2); // তথ্য, টিপস, নোটিফিকেশন
  static const Color error = Color(0xFFE53935); // এরর, ফেইল

  // ==========================================
  // ৩. ব্যাকগ্রাউন্ড ও সারফেস কালার
  // ==========================================
  static const Color background = Color(0xFFF5F6F8); // মেইন ব্যাকগ্রাউন্ড
  static const Color cardBackground = Colors.white; // কার্ডের ব্যাকগ্রাউন্ড
  static const Color divider = Color(0xFFE0E0E0); // ডিভাইডার লাইন

  // ==========================================
  // ৪. টেক্সট কালার
  // ==========================================
  static const Color textPrimary = Color(0xFF212121); // মূল কালো/গাঢ় ধূসর টেক্সট
  static const Color textSecondary = Color(0xFF757575); // সেকেন্ডারি টেক্সট (লেবেল, সাবটাইটেল)
  static const Color textHint = Color(0xFF9E9E9E); // প্লেসহোল্ডার বা হিন্ট টেক্সট
  static const Color textLight = Colors.white; // সাদা টেক্সট (কালারফুল ব্যাকগ্রাউন্ডের ওপর)

  // ==========================================
  // ৫. লেজার ক্যাটাগরি কালার (আয়-ব্যয় ভেদে)
  // ==========================================
  // আয়ের ক্যাটাগরি
  static const Color catSalary = Color(0xFF00897B); // বেতন (Teal)
  static const Color catBusiness = Color(0xFF43A047); // ব্যবসা (Green)
  static const Color catInvestment = Color(0xFF1E88E5); // বিনিয়োগ (Blue)
  static const Color catGift = Color(0xFF8E24AA); // উপহার (Purple)

  // ব্যয়ের ক্যাটাগরি
  static const Color catFood = Color(0xFFF4511E); // খাবার (Deep Orange)
  static const Color catTransport = Color(0xFF3949AB); // যাতায়াত (Indigo)
  static const Color catShopping = Color(0xFFD81B60); // কেনাকাটা (Pink)
  static const Color catBills = Color(0xFFFDD835); // বিল (Yellow)
  static const Color catHealth = Color(0xFFE53935); // চিকিৎসা (Red)
  static const Color catEducation = Color(0xFF00ACC1); // শিক্ষা (Cyan)
  static const Color catOthers = Color(0xFF757575); // অন্যান্য (Grey)

  // ==========================================
  // ৬. কুইজ ও গেমসের জন্য কালার
  // ==========================================
  static const Color quizCorrect = Color(0xFF4CAF50); // সঠিক উত্তর (সবুজ)
  static const Color quizWrong = Color(0xFFE53935); // ভুল উত্তর (লাল)
  static const Color quizTimerSafe = Color(0xFF1976D2); // টাইমার ঠিক আছে (নীল)
  static const Color quizTimerWarning = Color(0xFFF57C00); // টাইমার কমে আসছে (কমলা)
  static const Color quizTimerDanger = Color(0xFFD32F2F); // টাইমার শেষের পথে (লাল)

  // গেমস বাটন ও স্কোর
  static const Color gameGold = Color(0xFFFFB300); // গোল্ডেন/রেকর্ড স্কোর
  static const Color gameSilver = Color(0xFFB0BEC5); // সিলভার স্কোর
  static const Color gameBackground = Color(0xFF1A1A1A); // গেম খেলার সময় গাঢ় ব্যাকগ্রাউন্ড

  // ==========================================
  // ৭. চার্ট কালার (গ্রাফ ও পাই চার্টের জন্য)
  // ==========================================
  static const List<Color> chartColors = [
    Color(0xFF2E7D32), // Green
    Color(0xFF1976D2), // Blue
    Color(0xFFF57C00), // Orange
    Color(0xFFD32F2F), // Red
    Color(0xFF8E24AA), // Purple
    Color(0xFF00897B), // Teal
    Color(0xFFFBC02D), // Yellow
    Color(0xFFD81B60), // Pink
  ];
}
