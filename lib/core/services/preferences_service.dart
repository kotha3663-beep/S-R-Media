import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyLanguage = 'app_language';

  static Future<void> setLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, langCode);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'bn';
  }
}
