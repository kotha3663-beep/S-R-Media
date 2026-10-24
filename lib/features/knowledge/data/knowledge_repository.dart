import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/knowledge_item_model.dart';

class KnowledgeRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mywork_knowledge.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
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
        _insertInitialKnowledge(db);
      },
    );
  }

  Future<void> _insertInitialKnowledge(Database db) async {
    final items = [
      {
        'groupId': 1,
        'languageCode': 'bn',
        'category': 'বাংলাদেশ বিষয়াবলি',
        'title': 'বাংলাদেশের জাতীয় ফুল',
        'body': 'বাংলাদেশের জাতীয় ফুল হলো শাপলা (Nymphaea nouchali)। এটি ১৯৭১ সালে স্বাধীনতার পর জাতীয় ফুল হিসেবে ঘোষণা করা হয়। শাপলা সাধারণত বিল, পুকুর ও জলাশয়ে ফোটে।',
        'keyPoint': 'শাপলা = জাতীয় ফুল',
        'isRead': 0,
      },
      {
        'groupId': 1,
        'languageCode': 'en',
        'category': 'Bangladesh Affairs',
        'title': 'National Flower of Bangladesh',
        'body': 'The national flower of Bangladesh is the Water Lily (Nymphaea nouchali). It was declared as the national flower after independence in 1971. Water lilies usually bloom in bills, ponds, and water bodies.',
        'keyPoint': 'Water Lily = National Flower',
        'isRead': 0,
      },
      {
        'groupId': 2,
        'languageCode': 'bn',
        'category': 'বিজ্ঞান ও প্রযুক্তি',
        'title': 'আলোর গতিবেগ',
        'body': 'শূন্য মাধ্যমে আলোর গতিবেগ প্রতি সেকেন্ডে প্রায় ৩,০০,০০০ কিলোমিটার (২৯৯,৭৯২,৪৫৮ মিটার/সেকেন্ড)। এটি মহাবিশ্বের সর্বোচ্চ গতিবেগ।',
        'keyPoint': 'আলোর গতি = ৩ লক্ষ কিমি/সে',
        'isRead': 0,
      },
      {
        'groupId': 2,
        'languageCode': 'en',
        'category': 'Science & Technology',
        'title': 'Speed of Light',
        'body': 'The speed of light in a vacuum is approximately 300,000 kilometers per second (299,792,458 meters per second). It is the maximum speed in the universe.',
        'keyPoint': 'Speed of light = 300,000 km/s',
        'isRead': 0,
      },
    ];

    for (var item in items) {
      await db.insert('knowledge_items', item);
    }
  }

  Future<List<KnowledgeItemModel>> getItemsByLanguage(String langCode) async {
    final db = await database;
    final maps = await db.query(
      'knowledge_items',
      where: 'languageCode = ?',
      whereArgs: [langCode],
    );
    return List.generate(maps.length, (i) {
      return KnowledgeItemModel.fromMap(maps[i]);
    });
  }

  Future<void> markAsRead(int id) async {
    final db = await database;
    await db.update(
      'knowledge_items',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
