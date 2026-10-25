import '../models/health_tip_model.dart';
import '../../../core/database/database_helper.dart';

class HealthRepository {
  Future<List<HealthTipModel>> getAllTips() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('health_tips');
    return List.generate(maps.length, (i) {
      return HealthTipModel.fromMap(maps[i]);
    });
  }

  Future<void> toggleBookmark(int id, bool isBookmarked) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'health_tips',
      {'isBookmarked': isBookmarked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // প্রথমবার ডেটা ইনসার্ট করার জন্য
  Future<void> insertInitialTipsIfNeeded() async {
    final db = await DatabaseHelper.database;
    final count = await db.query('health_tips');
    if (count.isEmpty) {
      final tips = [
        {'title': 'প্রচুর পানি পান করুন', 'category': 'হাইড্রেশন', 'description': 'প্রতিদিন কমপক্ষে ৮ গ্লাস পানি পান করুন।', 'isBookmarked': 0},
        {'title': 'নিয়মিত ব্যায়াম করুন', 'category': 'ব্যায়াম', 'description': 'প্রতিদিন কমপক্ষে ৩০ মিনিট হাঁটুন।', 'isBookmarked': 0},
        {'title': 'পর্যাপ্ত ঘুম', 'category': 'ঘুম', 'description': 'প্রতিদিন ৭-৮ ঘণ্টা ঘুমানোর চেষ্টা করুন।', 'isBookmarked': 0},
        {'title': 'স্বাস্থ্যকর খাবার খান', 'category': 'পুষ্টি', 'description': 'ফাস্ট ফুড এড়িয়ে চলুন এবং শাকসবজি খান।', 'isBookmarked': 0},
      ];
      for (var tip in tips) {
        await db.insert('health_tips', tip);
      }
    }
  }
}
