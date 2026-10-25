import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/database/database_helper.dart';
import '../models/question_model.dart';

class WrongAnswersScreen extends StatefulWidget {
  final int quizResultId;

  const WrongAnswersScreen({super.key, required this.quizResultId});

  @override
  State<WrongAnswersScreen> createState() => _WrongAnswersScreenState();
}

class _WrongAnswersScreenState extends State<WrongAnswersScreen> {
  List<Map<String, dynamic>> _wrongAnswers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWrongAnswers();
  }

  Future<void> _loadWrongAnswers() async {
    final db = await DatabaseHelper.database;
    final answers = await db.query(
      'quiz_answers',
      where: 'quiz_result_id = ? AND is_correct = ?',
      whereArgs: [widget.quizResultId, 0],
    );

    List<Map<String, dynamic>> results = [];
    for (var ans in answers) {
      final qMaps = await db.query(
        'quiz_questions',
        where: 'id = ?',
        whereArgs: [ans['question_group_id']],
      );
      if (qMaps.isNotEmpty) {
        results.add({
          'question': QuestionModel.fromMap(qMaps.first),
          'selected': ans['selected_option'],
        });
      }
    }

    if (mounted) {
      setState(() {
        _wrongAnswers = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ভুল উত্তরসমূহ'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wrongAnswers.isEmpty
              ? const Center(child: Text('কোনো ভুল উত্তর নেই!'))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _wrongAnswers.length,
                  itemBuilder: (context, index) {
                    final data = _wrongAnswers[index];
                    final question = data['question'] as QuestionModel;
                    final selected = data['selected'] as int;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.questionText,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            if (selected >= 0 && selected < question.options.length)
                              Text(
                                'আপনার উত্তর: ${question.options[selected]}',
                                style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w500),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              'সঠিক উত্তর: ${question.options[question.correctOptionIndex]}',
                              style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              question.explanation,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
