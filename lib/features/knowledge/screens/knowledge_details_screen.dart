import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/knowledge_item_model.dart';

class KnowledgeDetailsScreen extends StatelessWidget {
  final KnowledgeItemModel item;

  const KnowledgeDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('বিস্তারিত তথ্য'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.knowledgeAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.category,
                style: const TextStyle(color: AppColors.knowledgeAccent, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 20),
            Text(
              item.body,
              style: const TextStyle(fontSize: 16, height: 1.6, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                border: Border.all(color: AppColors.success),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: AppColors.success),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'মূল পয়েন্ট: ${item.keyPoint}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
