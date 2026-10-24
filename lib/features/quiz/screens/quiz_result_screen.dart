import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/quiz_result_model.dart';
import '../data/quiz_repository.dart';

class QuizResultScreen extends StatefulWidget {
  final String category;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double accuracyPercent;
  final double totalScore;
  final double maxPossibleScore;
  final int averageTimeNs;
  final int fastestCorrectNs;
  final String grade;

  const QuizResultScreen({
    super.key,
    required this.category,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.accuracyPercent,
    required this.totalScore,
    required this.maxPossibleScore,
    required this.averageTimeNs,
    required this.fastestCorrectNs,
    required this.grade,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    final result = QuizResultModel(
      category: widget.category,
      totalQuestions: widget.totalQuestions,
      correctAnswers: widget.correctAnswers,
      wrongAnswers: widget.wrongAnswers,
      accuracyPercent: widget.accuracyPercent,
      totalScore: widget.totalScore,
      maxPossibleScore: widget.maxPossibleScore,
      averageTimeNs: widget.averageTimeNs,
      fastestCorrectNs: widget.fastestCorrectNs,
      grade: widget.grade,
      createdAt: DateTime.now(),
    );
    await QuizRepository().saveQuizResult(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ফলাফল')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.knowledgeAccent.withOpacity(0.1),
                border: Border.all(color: AppColors.knowledgeAccent, width: 4),
              ),
              child: Center(
                child: Text(
                  widget.grade,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.knowledgeAccent),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'স্কোর: ${widget.totalScore.toStringAsFixed(1)} / ${widget.maxPossibleScore.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildStatCard('সঠিক', '${widget.correctAnswers}', AppColors.success)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('ভুল', '${widget.wrongAnswers}', AppColors.error)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('সঠিকতা', '${widget.accuracyPercent.toStringAsFixed(1)}%', AppColors.secondary)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('গড় সময়', '${(widget.averageTimeNs / 1000000000).toStringAsFixed(3)} সে', AppColors.warning)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('দ্রুততম সঠিক', '${(widget.fastestCorrectNs / 1000000000).toStringAsFixed(3)} সে', AppColors.knowledgeAccent)),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('ফিরে যান', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
