import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mywork_main.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE quiz_answers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quiz_result_id INTEGER,
            question_group_id INTEGER,
            selected_option INTEGER,
            is_correct INTEGER,
            time_taken_ns INTEGER,
            points_earned REAL
          )
        ''');
        
        await db.execute('''
          CREATE TABLE quiz_records(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT UNIQUE,
            best_score_percent REAL,
            best_grade TEXT,
            fastest_correct_ns INTEGER,
            best_average_time_ns INTEGER,
            updated_at TEXT
          )
        ''');
      },
    );
  }
}
