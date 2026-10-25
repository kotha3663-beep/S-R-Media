import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/language_service.dart';
import 'quiz_history_screen.dart';
import 'wrong_answers_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int resultId;
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
    required this.resultId,
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
  Widget build(BuildContext context) {
    final isBn = LanguageService().currentLocale.languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'ফলাফল' : 'Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizHistoryScreen()));
            },
          )
        ],
      ),
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
                  grade,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.knowledgeAccent),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isBn 
                  ? 'স্কোর: ${totalScore.toStringAsFixed(1)} / ${maxPossibleScore.toStringAsFixed(0)}'
                  : 'Score: ${totalScore.toStringAsFixed(1)} / ${maxPossibleScore.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildStatCard(isBn ? 'সঠিক' : 'Correct', '$correctAnswers', AppColors.success)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(isBn ? 'ভুল' : 'Wrong', '$wrongAnswers', AppColors.error)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard(isBn ? 'সঠিকতা' : 'Accuracy', '${accuracyPercent.toStringAsFixed(1)}%', AppColors.secondary)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(isBn ? 'গড় সময়' : 'Avg Time', '${(averageTimeNs / 1000000000).toStringAsFixed(3)}s', AppColors.warning)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard(isBn ? 'দ্রুততম সঠিক' : 'Fastest Correct', '${(fastestCorrectNs / 1000000000).toStringAsFixed(3)}s', AppColors.knowledgeAccent)),
              ],
            ),
            const SizedBox(height: 32),
            if (wrongAnswers > 0)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => WrongAnswersScreen(quizResultId: resultId))
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isBn ? 'ভুল উত্তরগুলো দেখুন' : 'View Wrong Answers', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            const SizedBox(height: 16),
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
                child: Text(isBn ? 'ফিরে যান' : 'Go Back', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
