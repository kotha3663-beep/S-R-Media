import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('জ্ঞান ও কুইজ'),
          bottom: const TabBar(
            labelColor: AppColors.knowledgeAccent,
            indicatorColor: AppColors.knowledgeAccent,
            tabs: [
              Tab(text: 'জ্ঞানকোষ'),
              Tab(text: 'কুইজ'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _KnowledgeTab(),
            _QuizTab(),
          ],
        ),
      ),
    );
  }
}

class _KnowledgeTab extends StatelessWidget {
  const _KnowledgeTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildKnowledgeCard(
          'বাংলাদেশের জাতীয় ফুল',
          'বাংলাদেশের জাতীয় ফুল হলো শাপলা (Nymphaea nouchali)। এটি ১৯৭১ সালে স্বাধীনতার পর জাতীয় ফুল হিসেবে ঘোষণা করা হয়...',
          'বাংলাদেশ বিষয়াবলি',
        ),
        _buildKnowledgeCard(
          'সৌরজগতের বৃহত্তম গ্রহ',
          'সৌরজগতের বৃহত্তম গ্রহ হলো বৃহস্পতি (Jupiter)। এর ভর পৃথিবীর প্রায় ৩১৮ গুণ...',
          'বিজ্ঞান ও প্রযুক্তি',
        ),
      ],
    );
  }

  Widget _buildKnowledgeCard(String title, String body, String category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(body, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Chip(
              label: Text(category, style: const TextStyle(fontSize: 12)),
              backgroundColor: AppColors.knowledgeAccent.withOpacity(0.1),
              side: BorderSide.none,
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

class _QuizTab extends StatelessWidget {
  const _QuizTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz, size: 80, color: AppColors.knowledgeAccent.withOpacity(0.5)),
          const SizedBox(height: 24),
          const Text(
            'নিজেকে যাচাই করুন',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'সঠিকতা এবং দ্রুততার উপর ভিত্তি করে স্কোর',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.knowledgeAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('কুইজ শুরু করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
