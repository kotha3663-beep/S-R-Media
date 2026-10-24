import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentLanguage = 'bn';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await PreferencesService.getLanguage();
    setState(() {
      _currentLanguage = lang;
    });
  }

  Future<void> _changeLanguage(String lang) async {
    await PreferencesService.setLanguage(lang);
    setState(() {
      _currentLanguage = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সেটিংস'),
      ),
      body: ListView(
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
              trailing: _currentLanguage == 'bn' ? const Icon(Icons.check_circle, color: AppColors.success) : null,
              onTap: () => _changeLanguage('bn'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language, color: AppColors.secondary),
              title: const Text('English'),
              trailing: _currentLanguage == 'en' ? const Icon(Icons.check_circle, color: AppColors.success) : null,
              onTap: () => _changeLanguage('en'),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'অন্যান্য',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline, color: AppColors.secondary),
              title: Text('অ্যাপ সম্পর্কে'),
              subtitle: Text('ভার্সন ১.০.০'),
            ),
          ),
        ],
      ),
    );
  }
}
