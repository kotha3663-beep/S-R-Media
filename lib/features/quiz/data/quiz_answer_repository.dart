import 'package:sqflite/sqflite.dart';
import '../../../core/database/db_helper.dart';

class QuizAnswerRepository {
  Future<void> saveAnswer({
    required int quizResultId,
    required int questionGroupId,
    required int selectedOption,
    required bool isCorrect,
    required int timeTakenNs,
    required double pointsEarned,
  }) async {
    final db = await DbHelper.database;
    await db.insert('quiz_answers', {
      'quiz_result_id': quizResultId,
      'question_group_id': questionGroupId,
      'selected_option': selectedOption,
      'is_correct': isCorrect ? 1 : 0,
      'time_taken_ns': timeTakenNs,
      'points_earned': pointsEarned,
    });
  }

  Future<List<Map<String, dynamic>>> getAnswersByResultId(int resultId) async {
    final db = await DbHelper.database;
    return await db.query(
      'quiz_answers',
      where: 'quiz_result_id = ?',
      whereArgs: [resultId],
    );
  }
}
