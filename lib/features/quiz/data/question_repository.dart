import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/question_model.dart';

class QuestionRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mywork_questions.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
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
        _insertInitialQuestions(db);
      },
    );
  }

  Future<void> _insertInitialQuestions(Database db) async {
    final questions = [
      {
        'groupId': 1,
        'languageCode': 'bn',
        'category': 'বাংলাদেশ বিষয়াবলি',
        'difficulty': 'সহজ',
        'questionText': 'বাংলাদেশের জাতীয় ফুল কোনটি?',
        'options': 'শাপলা|||গোলাপ|||পদ্ম|||জবা',
        'correctOptionIndex': 0,
        'explanation': 'বাংলাদেশের জাতীয় ফুল হলো শাপলা। এটি ১৯৭১ সালে স্বাধীনতার পর জাতীয় ফুল হিসেবে ঘোষণা করা হয়।',
      },
      {
        'groupId': 1,
        'languageCode': 'en',
        'category': 'Bangladesh Affairs',
        'difficulty': 'Easy',
        'questionText': 'What is the national flower of Bangladesh?',
        'options': 'Water Lily|||Rose|||Lotus|||Hibiscus',
        'correctOptionIndex': 0,
        'explanation': 'The national flower of Bangladesh is the Water Lily. It was declared as the national flower after independence in 1971.',
      },
      {
        'groupId': 2,
        'languageCode': 'bn',
        'category': 'বিজ্ঞান ও প্রযুক্তি',
        'difficulty': 'মাঝারি',
        'questionText': 'শূন্য মাধ্যমে আলোর গতিবেগ কত?',
        'options': '৩,০০,০০০ কিমি/সে|||১,৫০,০০০ কিমি/সে|||২,০০,০০০ কিমি/সে|||৪,০০,০০০ কিমি/সে',
        'correctOptionIndex': 0,
        'explanation': 'শূন্য মাধ্যমে আলোর গতিবেগ প্রতি সেকেন্ডে প্রায় ৩,০০,০০০ কিলোমিটার।',
      },
      {
        'groupId': 2,
        'languageCode': 'en',
        'category': 'Science & Technology',
        'difficulty': 'Medium',
        'questionText': 'What is the speed of light in a vacuum?',
        'options': '300,000 km/s|||150,000 km/s|||200,000 km/s|||400,000 km/s',
        'correctOptionIndex': 0,
        'explanation': 'The speed of light in a vacuum is approximately 300,000 kilometers per second.',
      },
      {
        'groupId': 3,
        'languageCode': 'bn',
        'category': 'ইতিহাস',
        'difficulty': 'সহজ',
        'questionText': 'মুক্তিযুদ্ধ কত সালে হয়?',
        'options': '১৯৭১|||১৯৫২|||১৯৬৯|||১৯৭৫',
        'correctOptionIndex': 0,
        'explanation': 'বাংলাদেশের মুক্তিযুদ্ধ ১৯৭১ সালে হয়।',
      },
      {
        'groupId': 3,
        'languageCode': 'en',
        'category': 'History',
        'difficulty': 'Easy',
        'questionText': 'In which year did the Liberation War take place?',
        'options': '1971|||1952|||1969|||1975',
        'correctOptionIndex': 0,
        'explanation': 'The Liberation War of Bangladesh took place in 1971.',
      },
    ];

    for (var q in questions) {
      await db.insert('quiz_questions', q);
    }
  }

  Future<List<QuestionModel>> getQuestionsByLanguage(String langCode, String? category, int limit) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    
    if (category != null && category.isNotEmpty) {
      maps = await db.query(
        'quiz_questions',
        where: 'languageCode = ? AND category = ?',
        whereArgs: [langCode, category],
        limit: limit,
      );
    } else {
      maps = await db.query(
        'quiz_questions',
        where: 'languageCode = ?',
        whereArgs: [langCode],
        limit: limit,
      );
    }

    return List.generate(maps.length, (i) {
      return QuestionModel.fromMap(maps[i]);
    });
  }

  Future<List<String>> getCategories(String langCode) async {
    final db = await database;
    final maps = await db.query(
      'quiz_questions',
      columns: ['category'],
      where: 'languageCode = ?',
      whereArgs: [langCode],
      distinct: true,
    );
    return maps.map((e) => e['category'] as String).toList();
  }
}
