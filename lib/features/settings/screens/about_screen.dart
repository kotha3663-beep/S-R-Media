import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('অ্যাপ সম্পর্কে')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.work, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('MyWork', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const Text('Version 1.0.0', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            const Text(
              'একটি ৪-ইন-১ অফলাইন ইউটিলিটি ও গেমস অ্যাপ। এখানে আপনি দৈনন্দিন হিসাব রাখতে, মিনি গেমস খেলতে, স্বাস্থ্য টিপস পড়তে এবং সাধারণ জ্ঞান দিয়ে নিজেকে যাচাই করতে পারবেন।',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            const Text('Made with ❤️', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
