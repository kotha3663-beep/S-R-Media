import 'dart:math';
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
      version: 2,
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
        await _insertInitialQuestions(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _insertInitialQuestions(db);
        }
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
        'category': 'বাংলাদেশ বিষয়াবলি',
        'difficulty': 'সহজ',
        'questionText': 'বাংলাদেশের স্বাধীনতা দিবস কোনটি?',
        'options': '২৬ মার্চ|||১৬ ডিসেম্বর|||২১ ফেব্রুয়ারি|||১ জানুয়ারি',
        'correctOptionIndex': 0,
        'explanation': 'বাংলাদেশের স্বাধীনতা দিবস ২৬ মার্চ।',
      },
      {
        'groupId': 2,
        'languageCode': 'en',
        'category': 'Bangladesh Affairs',
        'difficulty': 'Easy',
        'questionText': 'When is the Independence Day of Bangladesh?',
        'options': '26 March|||16 December|||21 February|||1 January',
        'correctOptionIndex': 0,
        'explanation': 'The Independence Day of Bangladesh is 26 March.',
      },
      {
        'groupId': 3,
        'languageCode': 'bn',
        'category': 'বিজ্ঞান ও প্রযুক্তি',
        'difficulty': 'মাঝারি',
        'questionText': 'শূন্য মাধ্যমে আলোর গতিবেগ কত?',
        'options': '৩,০০,০০০ কিমি/সে|||১,৫০,০০০ কিমি/সে|||২,০০,০০০ কিমি/সে|||৪,০০,০০০ কিমি/সে',
        'correctOptionIndex': 0,
        'explanation': 'শূন্য মাধ্যমে আলোর গতিবেগ প্রতি সেকেন্ডে প্রায় ৩,০০,০০০ কিলোমিটার।',
      },
      {
        'groupId': 3,
        'languageCode': 'en',
        'category': 'Science & Technology',
        'difficulty': 'Medium',
        'questionText': 'What is the speed of light in a vacuum?',
        'options': '300,000 km/s|||150,000 km/s|||200,000 km/s|||400,000 km/s',
        'correctOptionIndex': 0,
        'explanation': 'The speed of light in a vacuum is approximately 300,000 kilometers per second.',
      },
      {
        'groupId': 4,
        'languageCode': 'bn',
        'category': 'ইতিহাস',
        'difficulty': 'সহজ',
        'questionText': 'মুক্তিযুদ্ধ কত সালে হয়?',
        'options': '১৯৭১|||১৯৫২|||১৯৬৯|||১৯৭৫',
        'correctOptionIndex': 0,
        'explanation': 'বাংলাদেশের মুক্তিযুদ্ধ ১৯৭১ সালে হয়।',
      },
      {
        'groupId': 4,
        'languageCode': 'en',
        'category': 'History',
        'difficulty': 'Easy',
        'questionText': 'In which year did the Liberation War take place?',
        'options': '1971|||1952|||1969|||1975',
        'correctOptionIndex': 0,
        'explanation': 'The Liberation War of Bangladesh took place in 1971.',
      },
      {
        'groupId': 5,
        'languageCode': 'bn',
        'category': 'ভূগোল',
        'difficulty': 'মাঝারি',
        'questionText': 'বাংলাদেশের মোট আয়তন কত?',
        'options': '১,৪৭,৫৭০ বর্গকিমি|||১,৪৫,০০০ বর্গকিমি|||১,৫০,০০০ বর্গকিমি|||১,৪৮,০০০ বর্গকিমি',
        'correctOptionIndex': 0,
        'explanation': 'বাংলাদেশের মোট আয়তন ১,৪৭,৫৭০ বর্গকিলোমিটার।',
      },
      {
        'groupId': 5,
        'languageCode': 'en',
        'category': 'Geography',
        'difficulty': 'Medium',
        'questionText': 'What is the total area of Bangladesh?',
        'options': '147,570 sq km|||145,000 sq km|||150,000 sq km|||148,000 sq km',
        'correctOptionIndex': 0,
        'explanation': 'The total area of Bangladesh is 147,570 square kilometers.',
      },
      {
        'groupId': 6,
        'languageCode': 'bn',
        'category': 'খেলাধুলা',
        'difficulty': 'কঠিন',
        'questionText': 'বাংলাদেশ ক্রিকেট দল প্রথম টেস্ট ম্যাচ জয়লাভ করে কোন সালে?',
        'options': '২০০৫|||২০০০|||২০০৮|||২০১০',
        'correctOptionIndex': 0,
        'explanation': 'বাংলাদেশ ক্রিকেট দল ২০০৫ সালে জিম্বাবুয়ের বিপক্ষে তাদের প্রথম টেস্ট ম্যাচ জয়লাভ করে।',
      },
      {
        'groupId': 6,
        'languageCode': 'en',
        'category': 'Sports',
        'difficulty': 'Hard',
        'questionText': 'In which year did the Bangladesh cricket team win their first Test match?',
        'options': '2005|||2000|||2008|||2010',
        'correctOptionIndex': 0,
        'explanation': 'The Bangladesh cricket team won their first Test match against Zimbabwe in 2005.',
      },
      {
        'groupId': 7,
        'languageCode': 'bn',
        'category': 'সাহিত্য ও সংস্কৃতি',
        'difficulty': 'মাঝারি',
        'questionText': 'রবীন্দ্রনাথ ঠাকুর কোন সালে নোবেল পুরস্কার লাভ করেন?',
        'options': '১৯১৩|||১৯১০|||১৯২০|||১৯১৫',
        'correctOptionIndex': 0,
        'explanation': 'রবীন্দ্রনাথ ঠাকুর ১৯১৩ সালে সাহিত্যে নোবেল পুরস্কার লাভ করেন।',
      },
      {
        'groupId': 7,
        'languageCode': 'en',
        'category': 'Literature & Culture',
        'difficulty': 'Medium',
        'questionText': 'In which year did Rabindranath Tagore win the Nobel Prize?',
        'options': '1913|||1910|||1920|||1915',
        'correctOptionIndex': 0,
        'explanation': 'Rabindranath Tagore won the Nobel Prize in Literature in 1913.',
      },
      {
        'groupId': 8,
        'languageCode': 'bn',
        'category': 'কম্পিউটার ও ডিজিটাল জ্ঞান',
        'difficulty': 'সহজ',
        'questionText': 'কম্পিউটারের জনক কে?',
        'options': 'চার্লস ব্যাবেজ|||অ্যালান টুরিং|||বিল গেটস|||স্টিভ জবস',
        'correctOptionIndex': 0,
        'explanation': 'চার্লস ব্যাবেজকে কম্পিউটারের জনক বলা হয়।',
      },
      {
        'groupId': 8,
        'languageCode': 'en',
        'category': 'Computer & Digital Knowledge',
        'difficulty': 'Easy',
        'questionText': 'Who is the father of the computer?',
        'options': 'Charles Babbage|||Alan Turing|||Bill Gates|||Steve Jobs',
        'correctOptionIndex': 0,
        'explanation': 'Charles Babbage is known as the father of the computer.',
      },
      {
        'groupId': 9,
        'languageCode': 'bn',
        'category': 'স্বাস্থ্য ও দৈনন্দিন বিজ্ঞান',
        'difficulty': 'সহজ',
        'questionText': 'প্রতিদিন কমপক্ষে কত গ্লাস পানি পান করা উচিত?',
        'options': '৮ গ্লাস|||৪ গ্লাস|||৬ গ্লাস|||১০ গ্লাস',
        'correctOptionIndex': 0,
        'explanation': 'প্রতিদিন কমপক্ষে ৮ গ্লাস পানি পান করা উচিত।',
      },
      {
        'groupId': 9,
        'languageCode': 'en',
        'category': 'Health & Daily Science',
        'difficulty': 'Easy',
        'questionText': 'How many glasses of water should you drink daily at least?',
        'options': '8 glasses|||4 glasses|||6 glasses|||10 glasses',
        'correctOptionIndex': 0,
        'explanation': 'You should drink at least 8 glasses of water every day.',
      },
    ];

    for (var q in questions) {
      await db.insert('quiz_questions', q);
    }
  }

  Future<List<QuestionModel>> generateQuestionsFromKnowledge(String langCode, String? category, int limit) async {
    final dbPath = await getDatabasesPath();
    final kPath = join(dbPath, 'mywork_knowledge.db');
    
    List<Map<String, dynamic>> knowledgeItems = [];
    try {
      final kDb = await openDatabase(kPath, readOnly: true);
      if (category != null && category.isNotEmpty) {
        knowledgeItems = await kDb.query(
          'knowledge_items',
          where: 'languageCode = ? AND category = ?',
          whereArgs: [langCode, category],
        );
      } else {
        knowledgeItems = await kDb.query(
          'knowledge_items',
          where: 'languageCode = ?',
          whereArgs: [langCode],
        );
      }
      await kDb.close();
    } catch (e) {
      return await getQuestionsByLanguage(langCode, category, limit);
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
        correctIndex = 0;
        options.shuffle(random);
        correctIndex = options.indexOf(keyPoint);

        generatedQuestions.add(QuestionModel(
          groupId: item['groupId'],
          languageCode: langCode,
          category: cat,
          difficulty: 'মাঝারি',
          questionText: '$title - এর মূল পয়েন্ট কোনটি?',
          options: options,
          correctOptionIndex: correctIndex,
          explanation: body,
        ));
      } else {
        options = [keyPoint, 'None of these', 'Unknown', 'False info'];
        correctIndex = 0;
        options.shuffle(random);
        correctIndex = options.indexOf(keyPoint);

        generatedQuestions.add(QuestionModel(
          groupId: item['groupId'],
          languageCode: langCode,
          category: cat,
          difficulty: 'Medium',
          questionText: 'What is the key point of $title?',
          options: options,
          correctOptionIndex: correctIndex,
          explanation: body,
        ));
      }
    }

    return generatedQuestions;
  }

  Future<List<QuestionModel>> getQuestionsByLanguage(String langCode, String? category, int limit) async {
    final db = await database;
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
