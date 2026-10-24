import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/quiz_result_model.dart';
import '../data/quiz_repository.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  final _repository = QuizRepository();
  List<QuizResultModel> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final results = await _repository.getAllResults();
    if (mounted) {
      setState(() {
        _results = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('কুইজ ইতিহাস'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('কোনো ইতিহাস নেই'))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final res = _results[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(res.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.knowledgeAccent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(res.grade, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('স্কোর: ${res.totalScore.toStringAsFixed(1)} / ${res.maxPossibleScore.toStringAsFixed(0)}'),
                            Text('সঠিক: ${res.correctAnswers}/${res.totalQuestions} | সঠিকতা: ${res.accuracyPercent.toStringAsFixed(1)}%'),
                            Text('গড় সময়: ${(res.averageTimeNs / 1000000000).toStringAsFixed(3)} সে'),
                            Text(
                              '${res.createdAt.day}/${res.createdAt.month}/${res.createdAt.year} ${res.createdAt.hour}:${res.createdAt.minute}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
