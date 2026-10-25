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

  Future<void> insertInitialTipsIfNeeded() async {
    final db = await DatabaseHelper.database;
    final count = await db.query('health_tips');
    if (count.isEmpty) {
      final tips = [
        {'title': 'প্রচুর পানি পান করুন', 'category': 'হাইড্রেশন', 'description': 'প্রতিদিন কমপক্ষে ৮ গ্লাস পানি পান করুন। এটি আপনার ত্বক এবং শরীরকে সতেজ রাখতে সাহায্য করবে।', 'isBookmarked': 0},
        {'title': 'নিয়মিত ব্যায়াম করুন', 'category': 'ব্যায়াম', 'description': 'প্রতিদিন কমপক্ষে ৩০ মিনিট হাঁটুন বা হালকা ব্যায়াম করুন। এটি হার্টের স্বাস্থ্যের জন্য ভালো।', 'isBookmarked': 0},
        {'title': 'পর্যাপ্ত ঘুম', 'category': 'ঘুম', 'description': 'প্রতিদিন ৭-৮ ঘণ্টা ঘুমানোর চেষ্টা করুন। ঘুমের অভাবে মনোযোগ কমে যায়।', 'isBookmarked': 0},
        {'title': 'স্বাস্থ্যকর খাবার খান', 'category': 'পুষ্টি', 'description': 'ফাস্ট ফুড এড়িয়ে চলুন এবং বেশি বেশি শাকসবজি ও ফলমূল খান।', 'isBookmarked': 0},
        {'title': 'হাত ধোয়ার অভ্যাস', 'category': 'পরিচ্ছন্নতা', 'description': 'খাওয়ার আগে এবং বাথরুম ব্যবহারের পর সাবান দিয়ে হাত ধুয়ে নিন।', 'isBookmarked': 0},
        {'title': 'স্ট্রেস কমান', 'category': 'মানসিক স্বাস্থ্য', 'description': 'প্রতিদিন কিছুটা সময় ধ্যান বা প্রাণায়ামের জন্য রাখুন।', 'isBookmarked': 0},
        {'title': 'চোখের যত্ন নিন', 'category': 'স্বাস্থ্য', 'description': 'দীর্ঘক্ষণ মোবাইল বা কম্পিউটার ব্যবহারের পর ২০ সেকেন্ডের জন্য দূরে তাকান।', 'isBookmarked': 0},
        {'title': 'সঠিক সময়ে খাবার খান', 'category': 'পুষ্টি', 'description': 'প্রতিদিন নির্দিষ্ট সময়ে সকাল, দুপুর ও রাতের খাবার খাওয়ার অভ্যাস গড়ুন।', 'isBookmarked': 0},
      ];
      for (var tip in tips) {
        await db.insert('health_tips', tip);
      }
    }
  }
}
