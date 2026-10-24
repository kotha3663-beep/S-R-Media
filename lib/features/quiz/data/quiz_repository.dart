import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/quiz_result_model.dart';

class QuizRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mywork_quiz.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE quiz_results(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT,
            totalQuestions INTEGER,
            correctAnswers INTEGER,
            wrongAnswers INTEGER,
            accuracyPercent REAL,
            totalScore REAL,
            maxPossibleScore REAL,
            averageTimeNs INTEGER,
            fastestCorrectNs INTEGER,
            grade TEXT,
            createdAt TEXT
          )
        ''');
      },
    );
  }

  Future<int> saveQuizResult(QuizResultModel result) async {
    final db = await database;
    return await db.insert('quiz_results', result.toMap());
  }

  Future<List<QuizResultModel>> getAllResults() async {
    final db = await database;
    final maps = await db.query('quiz_results', orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) {
      return QuizResultModel.fromMap(maps[i]);
    });
  }
}
