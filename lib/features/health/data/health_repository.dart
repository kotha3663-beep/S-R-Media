import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_tip_model.dart';

class HealthRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mywork_health.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE health_tips(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            category TEXT,
            description TEXT,
            isBookmarked INTEGER
          )
        ''');
        _insertInitialTips(db);
      },
    );
  }

  Future<void> _insertInitialTips(Database db) async {
    final tips = [
      {
        'title': 'প্রচুর পানি পান করুন',
        'category': 'হাইড্রেশন',
        'description': 'প্রতিদিন কমপক্ষে ৮ গ্লাস পানি পান করুন। এটি আপনার ত্বক এবং শরীরকে সতেজ রাখতে সাহায্য করবে।',
        'isBookmarked': 0,
      },
      {
        'title': 'নিয়মিত ব্যায়াম করুন',
        'category': 'ব্যায়াম',
        'description': 'প্রতিদিন কমপক্ষে ৩০ মিনিট হাঁটুন বা হালকা ব্যায়াম করুন। এটি হার্টের স্বাস্থ্যের জন্য ভালো।',
        'isBookmarked': 0,
      },
      {
        'title': 'পর্যাপ্ত ঘুম',
        'category': 'ঘুম',
        'description': 'প্রতিদিন ৭-৮ ঘণ্টা ঘুমানোর চেষ্টা করুন। ঘুমের অভাবে মনোযোগ কমে যায়।',
        'isBookmarked': 0,
      },
      {
        'title': 'স্বাস্থ্যকর খাবার খান',
        'category': 'পুষ্টি',
        'description': 'ফাস্ট ফুড এড়িয়ে চলুন এবং বেশি বেশি শাকসবজি ও ফলমূল খান।',
        'isBookmarked': 0,
      },
    ];

    for (var tip in tips) {
      await db.insert('health_tips', tip);
    }
  }

  Future<List<HealthTipModel>> getAllTips() async {
    final db = await database;
    final maps = await db.query('health_tips');
    return List.generate(maps.length, (i) {
      return HealthTipModel.fromMap(maps[i]);
    });
  }

  Future<void> toggleBookmark(int id, bool isBookmarked) async {
    final db = await database;
    await db.update(
      'health_tips',
      {'isBookmarked': isBookmarked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
