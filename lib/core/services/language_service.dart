import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  Locale _currentLocale = const Locale('bn');
  Locale get currentLocale => _currentLocale;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('app_language') ?? 'bn';
    _currentLocale = Locale(langCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String langCode) async {
    if (_currentLocale.languageCode == langCode) return;
    _currentLocale = Locale(langCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', langCode);
    notifyListeners();
  }
}
