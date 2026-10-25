import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mywork.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // ১. লেজার টেবিল
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            amount REAL,
            category TEXT,
            date TEXT,
            note TEXT
          )
        ''');

        // ২. গেম রেকর্ড টেবিল
        await db.execute('''
          CREATE TABLE game_records(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            gameId TEXT UNIQUE,
            highScore INTEGER,
            lastLevel INTEGER,
            lastPlayed TEXT
          )
        ''');

        // ৩. হেলথ টিপস টেবিল
        await db.execute('''
          CREATE TABLE health_tips(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            category TEXT,
            description TEXT,
            isBookmarked INTEGER
          )
        ''');

        // ৪. জ্ঞানকোষ টেবিল
        await db.execute('''
          CREATE TABLE knowledge_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            groupId INTEGER,
            languageCode TEXT,
            category TEXT,
            title TEXT,
            body TEXT,
            keyPoint TEXT,
            isRead INTEGER
          )
        ''');

        // ৫. কুইজ প্রশ্ন টেবিল
        await db.execute('''
          CREATE TABLE quiz_questions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            groupId INTEGER,
            languageCode TEXT,
            category TEXT,
            difficulty TEXT,
            questionText TEXT,
            options TEXT,
            correctOptionIndex INTEGER,
            explanation TEXT
          )
        ''');

        // ৬. কুইজ রেজাল্ট টেবিল
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

        // ৭. কুইজ উত্তর টেবিল (রেজাল্টের সাথে লিংকড)
        await db.execute('''
          CREATE TABLE quiz_answers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quiz_result_id INTEGER,
            question_group_id INTEGER,
            selected_option INTEGER,
            is_correct INTEGER,
            time_taken_ns INTEGER,
            points_earned REAL,
            FOREIGN KEY (quiz_result_id) REFERENCES quiz_results(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}
