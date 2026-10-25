import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/quiz_result_model.dart';

class QuizRepository {
  Future<int> saveQuizResultAndGetId({
    required String category,
    required int totalQuestions,
    required int correctAnswers,
    required int wrongAnswers,
    required double accuracyPercent,
    required double totalScore,
    required double maxPossibleScore,
    required int averageTimeNs,
    required int fastestCorrectNs,
    required String grade,
    required List<Map<String, dynamic>> answers,
  }) async {
    final db = await DatabaseHelper.database;
    
    return await db.transaction((txn) async {
      final resultId = await txn.insert('quiz_results', {
        'category': category,
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'wrongAnswers': wrongAnswers,
        'accuracyPercent': accuracyPercent,
        'totalScore': totalScore,
        'maxPossibleScore': maxPossibleScore,
        'averageTimeNs': averageTimeNs,
        'fastestCorrectNs': fastestCorrectNs,
        'grade': grade,
        'createdAt': DateTime.now().toIso8601String(),
      });

      for (var ans in answers) {
        await txn.insert('quiz_answers', {
          'quiz_result_id': resultId,
          'question_text': ans['questionText'],
          'options': ans['options'],
          'correct_option_index': ans['correctOptionIndex'],
          'selected_option': ans['selectedOption'],
          'is_correct': ans['isCorrect'] ? 1 : 0,
          'time_taken_ns': ans['timeTakenNs'],
          'points_earned': ans['pointsEarned'],
          'explanation': ans['explanation'],
        });
      }

      return resultId;
    });
  }

  Future<List<QuizResultModel>> getAllResults() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('quiz_results', orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) {
      return QuizResultModel.fromMap(maps[i]);
    });
  }
}
