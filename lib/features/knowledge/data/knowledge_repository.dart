import '../models/knowledge_item_model.dart';
import '../../../core/database/database_helper.dart';

class KnowledgeRepository {
  Future<List<KnowledgeItemModel>> getItemsByLanguage(String langCode) async {
    final db = await DatabaseHelper.database;
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
    final db = await DatabaseHelper.database;
    await db.update(
      'knowledge_items',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertInitialDataIfNeeded() async {
    final db = await DatabaseHelper.database;
    final count = await db.query('knowledge_items');
    if (count.isEmpty) {
      final data = [
        // বাংলা তথ্য
        {'groupId': 1, 'languageCode': 'bn', 'category': 'বাংলাদেশ বিষয়াবলি', 'title': 'বাংলাদেশের জাতীয় ফুল', 'body': 'বাংলাদেশের জাতীয় ফুল হলো শাপলা (Nymphaea nouchali)। এটি ১৯৭১ সালে স্বাধীনতার পর জাতীয় ফুল হিসেবে ঘোষণা করা হয়।', 'keyPoint': 'শাপলা = জাতীয় ফুল', 'isRead': 0},
        {'groupId': 2, 'languageCode': 'bn', 'category': 'বিজ্ঞান ও প্রযুক্তি', 'title': 'আলোর গতিবেগ', 'body': 'শূন্য মাধ্যমে আলোর গতিবেগ প্রতি সেকেন্ডে প্রায় ৩,০০,০০০ কিলোমিটার। এটি মহাবিশ্বের সর্বোচ্চ গতিবেগ।', 'keyPoint': 'আলোর গতি = ৩ লক্ষ কিমি/সে', 'isRead': 0},
        {'groupId': 3, 'languageCode': 'bn', 'category': 'ইতিহাস', 'title': 'মুক্তিযুদ্ধ', 'body': 'বাংলাদেশের মুক্তিযুদ্ধ ১৯৭১ সালে সংঘটিত হয়। ৯ মাস রক্তক্ষয়ী যুদ্ধের পর ১৬ ডিসেম্বর বিজয় লাভ হয়।', 'keyPoint': 'মুক্তিযুদ্ধ = ১৯৭১', 'isRead': 0},
        {'groupId': 4, 'languageCode': 'bn', 'category': 'ভূগোল', 'title': 'বাংলাদেশের আয়তন', 'body': 'বাংলাদেশের মোট আয়তন ১,৪৭,৫৭০ বর্গকিলোমিটার। এটি দক্ষিণ এশিয়ায় অবস্থিত।', 'keyPoint': 'আয়তন = ১,৪৭,৫৭০ বর্গকিমি', 'isRead': 0},
        {'groupId': 5, 'languageCode': 'bn', 'category': 'খেলাধুলা', 'title': 'প্রথম টেস্ট জয়', 'body': 'বাংলাদেশ ক্রিকেট দল ২০০৫ সালে জিম্বাবুয়ের বিপক্ষে প্রথম টেস্ট ম্যাচ জয়লাভ করে।', 'keyPoint': 'প্রথম টেস্ট জয় = ২০০৫', 'isRead': 0},
        {'groupId': 6, 'languageCode': 'bn', 'category': 'সাহিত্য ও সংস্কৃতি', 'title': 'রবীন্দ্রনাথ ঠাকুর', 'body': 'রবীন্দ্রনাথ ঠাকুর ১৯১৩ সালে সাহিত্যে নোবেল পুরস্কার লাভ করেন। তার বিখ্যাত কাব্যগ্রন্থ "গীতাঞ্জলি"।', 'keyPoint': 'নোবেল = ১৯১৩', 'isRead': 0},
        {'groupId': 7, 'languageCode': 'bn', 'category': 'কম্পিউটার ও ডিজিটাল জ্ঞান', 'title': 'কম্পিউটারের জনক', 'body': 'চার্লস ব্যাবেজকে কম্পিউটারের জনক বলা হয়। তিনি প্রথম যান্ত্রিক কম্পিউটার ডিজাইন করেন।', 'keyPoint': 'কম্পিউটারের জনক = চার্লস ব্যাবেজ', 'isRead': 0},
        {'groupId': 8, 'languageCode': 'bn', 'category': 'স্বাস্থ্য ও দৈনন্দিন বিজ্ঞান', 'title': 'পানির গুরুত্ব', 'body': 'মানবদেহের প্রায় ৬০% পানি। প্রতিদিন কমপক্ষে ৮ গ্লাস পানি পান করা উচিত।', 'keyPoint': 'প্রতিদিন ৮ গ্লাস পানি', 'isRead': 0},
        {'groupId': 9, 'languageCode': 'bn', 'category': 'বাংলাদেশ বিষয়াবলি', 'title': 'বাংলাদেশের রাজধানী', 'body': 'বাংলাদেশের রাজধানী ঢাকা। এটি বাংলাদেশের সবচেয়ে বড় শহর।', 'keyPoint': 'রাজধানী = ঢাকা', 'isRead': 0},
        {'groupId': 10, 'languageCode': 'bn', 'category': 'বিজ্ঞান ও প্রযুক্তি', 'title': 'সৌরজগতের বৃহত্তম গ্রহ', 'body': 'সৌরজগতের বৃহত্তম গ্রহ হলো বৃহস্পতি (Jupiter)।', 'keyPoint': 'বৃহত্তম গ্রহ = বৃহস্পতি', 'isRead': 0},
        {'groupId': 11, 'languageCode': 'bn', 'category': 'ইতিহাস', 'title': 'বিশ্বযুদ্ধ', 'body': 'প্রথম বিশ্বযুদ্ধ শুরু হয় ১৯১৪ সালে এবং দ্বিতীয় বিশ্বযুদ্ধ শুরু হয় ১৯৩৯ সালে।', 'keyPoint': '১ম বিশ্বযুদ্ধ = ১৯১৪', 'isRead': 0},
        {'groupId': 12, 'languageCode': 'bn', 'category': 'ভূগোল', 'title': 'বৃহত্তম মহাসাগর', 'body': 'পৃথিবীর বৃহত্তম মহাসাগর হলো প্রশান্ত মহাসাগর।', 'keyPoint': 'বৃহত্তম মহাসাগর = প্রশান্ত', 'isRead': 0},
        
        // ইংরেজি তথ্য
        {'groupId': 1, 'languageCode': 'en', 'category': 'Bangladesh Affairs', 'title': 'National Flower', 'body': 'The national flower of Bangladesh is the Water Lily (Nymphaea nouchali). It was declared after independence in 1971.', 'keyPoint': 'Water Lily = National Flower', 'isRead': 0},
        {'groupId': 2, 'languageCode': 'en', 'category': 'Science & Technology', 'title': 'Speed of Light', 'body': 'The speed of light in a vacuum is approximately 300,000 kilometers per second.', 'keyPoint': 'Speed of light = 300,000 km/s', 'isRead': 0},
        {'groupId': 3, 'languageCode': 'en', 'category': 'History', 'title': 'Liberation War', 'body': 'The Liberation War of Bangladesh took place in 1971. Victory was achieved on December 16 after 9 months.', 'keyPoint': 'Liberation War = 1971', 'isRead': 0},
        {'groupId': 4, 'languageCode': 'en', 'category': 'Geography', 'title': 'Area of Bangladesh', 'body': 'The total area of Bangladesh is 147,570 square kilometers. It is located in South Asia.', 'keyPoint': 'Area = 147,570 sq km', 'isRead': 0},
        {'groupId': 5, 'languageCode': 'en', 'category': 'Sports', 'title': 'First Test Win', 'body': 'The Bangladesh cricket team won their first Test match against Zimbabwe in 2005.', 'keyPoint': 'First Test Win = 2005', 'isRead': 0},
        {'groupId': 6, 'languageCode': 'en', 'category': 'Literature & Culture', 'title': 'Rabindranath Tagore', 'body': 'Rabindranath Tagore won the Nobel Prize in Literature in 1913. His famous poetry collection is "Gitanjali".', 'keyPoint': 'Nobel = 1913', 'isRead': 0},
        {'groupId': 7, 'languageCode': 'en', 'category': 'Computer & Digital Knowledge', 'title': 'Father of Computer', 'body': 'Charles Babbage is known as the father of the computer. He designed the first mechanical computer.', 'keyPoint': 'Father of Computer = Charles Babbage', 'isRead': 0},
        {'groupId': 8, 'languageCode': 'en', 'category': 'Health & Daily Science', 'title': 'Importance of Water', 'body': 'About 60% of the human body is water. You should drink at least 8 glasses of water every day.', 'keyPoint': '8 glasses daily', 'isRead': 0},
        {'groupId': 9, 'languageCode': 'en', 'category': 'Bangladesh Affairs', 'title': 'Capital of Bangladesh', 'body': 'The capital of Bangladesh is Dhaka. It is the largest city in Bangladesh.', 'keyPoint': 'Capital = Dhaka', 'isRead': 0},
        {'groupId': 10, 'languageCode': 'en', 'category': 'Science & Technology', 'title': 'Largest Planet', 'body': 'The largest planet in the solar system is Jupiter.', 'keyPoint': 'Largest Planet = Jupiter', 'isRead': 0},
        {'groupId': 11, 'languageCode': 'en', 'category': 'History', 'title': 'World Wars', 'body': 'World War I started in 1914 and World War II started in 1939.', 'keyPoint': 'WW1 = 1914', 'isRead': 0},
        {'groupId': 12, 'languageCode': 'en', 'category': 'Geography', 'title': 'Largest Ocean', 'body': 'The largest ocean on Earth is the Pacific Ocean.', 'keyPoint': 'Largest Ocean = Pacific', 'isRead': 0},
      ];

      for (var item in data) {
        await db.insert('knowledge_items', item);
      }
    }
  }
}
