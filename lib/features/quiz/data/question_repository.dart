import 'dart:math';
import '../models/question_model.dart';
import '../../../core/database/database_helper.dart';

class QuestionRepository {
  Future<List<QuestionModel>> getQuestionsByLanguage(String langCode, String? category, int limit) async {
    final db = await DatabaseHelper.database;
    List<Map<String, dynamic>> maps;
    
    if (category != null && category.isNotEmpty) {
      maps = await db.query(
        'quiz_questions',
        where: 'languageCode = ? AND category = ?',
        whereArgs: [langCode, category],
      );
    } else {
      maps = await db.query(
        'quiz_questions',
        where: 'languageCode = ?',
        whereArgs: [langCode],
      );
    }

    maps.shuffle(Random());
    final selectedMaps = maps.take(limit).toList();

    return List.generate(selectedMaps.length, (i) {
      return QuestionModel.fromMap(selectedMaps[i]);
    });
  }

  Future<List<String>> getCategories(String langCode) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'quiz_questions',
      columns: ['category'],
      where: 'languageCode = ?',
      whereArgs: [langCode],
      distinct: true,
    );
    return maps.map((e) => e['category'] as String).toList();
  }

  Future<List<QuestionModel>> generateQuestionsFromKnowledge(String langCode, String? category, int limit) async {
    final db = await DatabaseHelper.database;
    List<Map<String, dynamic>> knowledgeItems;
    
    if (category != null && category.isNotEmpty) {
      knowledgeItems = await db.query(
        'knowledge_items',
        where: 'languageCode = ? AND category = ?',
        whereArgs: [langCode, category],
      );
    } else {
      knowledgeItems = await db.query(
        'knowledge_items',
        where: 'languageCode = ?',
        whereArgs: [langCode],
      );
    }

    if (knowledgeItems.isEmpty) {
      return await getQuestionsByLanguage(langCode, category, limit);
    }

    knowledgeItems.shuffle(Random());
    final selectedItems = knowledgeItems.take(limit).toList();
    final List<QuestionModel> generatedQuestions = [];
    final random = Random();

    for (var item in selectedItems) {
      final title = item['title'] as String;
      final keyPoint = item['keyPoint'] as String;
      final body = item['body'] as String;
      final cat = item['category'] as String;
      
      List<String> options = [];
      int correctIndex = 0;
      
      if (langCode == 'bn') {
        options = [keyPoint, 'কোনোটিই নয়', 'অজানা', 'ভুল তথ্য'];
      } else {
        options = [keyPoint, 'None of these', 'Unknown', 'False info'];
      }
      
      options.shuffle(random);
      correctIndex = options.indexOf(keyPoint);

      generatedQuestions.add(QuestionModel(
        groupId: item['groupId'],
        languageCode: langCode,
        category: cat,
        difficulty: 'মাঝারি',
        questionText: langCode == 'bn' ? '$title - এর মূল পয়েন্ট কোনটি?' : 'What is the key point of $title?',
        options: options,
        correctOptionIndex: correctIndex,
        explanation: body,
      ));
    }

    return generatedQuestions;
  }
}
