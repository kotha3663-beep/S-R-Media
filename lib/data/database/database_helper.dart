import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mywork.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE knowledge_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        key_point TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        language_code TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        knowledge_item_id INTEGER NOT NULL,
        question_text TEXT NOT NULL,
        options TEXT NOT NULL,
        correct_option_index INTEGER NOT NULL,
        explanation TEXT NOT NULL,
        category TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        FOREIGN KEY (knowledge_item_id) REFERENCES knowledge_items (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        quiz_type TEXT NOT NULL,
        total_questions INTEGER NOT NULL,
        correct_answers INTEGER NOT NULL,
        wrong_answers INTEGER NOT NULL,
        accuracy_percent REAL NOT NULL,
        total_score REAL NOT NULL,
        max_possible_score REAL NOT NULL,
        score_percent REAL NOT NULL,
        total_time_ns INTEGER NOT NULL,
        average_time_ns INTEGER NOT NULL,
        fastest_correct_ns INTEGER NOT NULL,
        slowest_correct_ns INTEGER NOT NULL,
        grade TEXT NOT NULL,
        timer_enabled INTEGER NOT NULL,
        per_question_time_sec INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quiz_result_id INTEGER NOT NULL,
        question_id INTEGER NOT NULL,
        selected_option INTEGER NOT NULL,
        is_correct INTEGER NOT NULL,
        time_taken_ns INTEGER NOT NULL,
        points_earned REAL NOT NULL,
        speed_points REAL NOT NULL,
        FOREIGN KEY (quiz_result_id) REFERENCES quiz_results (id) ON DELETE CASCADE,
        FOREIGN KEY (question_id) REFERENCES quiz_questions (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
