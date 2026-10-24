import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/language_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langService = LanguageService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('সেটিংস / Settings'),
      ),
      body: ListenableBuilder(
        listenable: langService,
        builder: (context, _) {
          final currentLang = langService.currentLocale.languageCode;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                'ভাষা / Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.language, color: AppColors.secondary),
                  title: const Text('বাংলা'),
                  trailing: currentLang == 'bn' ? const Icon(Icons.check_circle, color: AppColors.success) : null,
                  onTap: () => langService.changeLanguage('bn'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.language, color: AppColors.secondary),
                  title: const Text('English'),
                  trailing: currentLang == 'en' ? const Icon(Icons.check_circle, color: AppColors.success) : null,
                  onTap: () => langService.changeLanguage('en'),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'অন্যান্য / Others',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline, color: AppColors.secondary),
                  title: Text('অ্যাপ সম্পর্কে / About App'),
                  subtitle: Text('Version 1.0.0'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
