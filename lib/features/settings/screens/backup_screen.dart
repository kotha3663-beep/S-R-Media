import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/backup_service.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _isProcessing = false;

  void _handleBackup() async {
    setState(() => _isProcessing = true);
    final path = await BackupService.exportDatabase();
    setState(() => _isProcessing = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(path != null ? 'ব্যাকআপ সফল হয়েছে: $path' : 'ব্যাকআপ ব্যর্থ হয়েছে')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ডেটা ব্যাকআপ')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ফোন পরিবর্তন বা অ্যাপ মুছে ফেলার আগে অবশ্যই ব্যাকআপ নিন। অন্যথায় আপনার সব ডেটা হারিয়ে যাবে।',
                      style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _handleBackup,
              icon: _isProcessing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.upload_file),
              label: const Text('ব্যাকআপ নিন (Export)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : () {
                // ফাইল পিকার ব্যবহার করে রিস্টোর করার লজিক
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('রিস্টোর ফিচারটি পরবর্তী আপডেটে আসছে।')),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('রিস্টোর করুন (Import)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
