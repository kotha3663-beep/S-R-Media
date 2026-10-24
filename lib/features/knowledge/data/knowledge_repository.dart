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
        await _insertInitialData(db);
      },
    );
  }

  Future<void> _insertInitialData(Database db) async {
    final data = [
      {
        'groupId': 1,
        'languageCode': 'bn',
        'category': 'বাংলাদেশ বিষয়াবলি',
        'title': 'বাংলাদেশের জাতীয় ফুল',
        'body': 'বাংলাদেশের জাতীয় ফুল হলো শাপলা (Nymphaea nouchali)। এটি ১৯৭১ সালে স্বাধীনতার পর জাতীয় ফুল হিসেবে ঘোষণা করা হয়। শাপলা সাধারণত বিল, পুকুর ও জলাশয়ে ফোটে। এটি বাংলার প্রকৃতির এক অনন্য সৌন্দর্য।',
        'keyPoint': 'শাপলা = জাতীয় ফুল',
        'isRead': 0,
      },
      {
        'groupId': 1,
        'languageCode': 'en',
        'category': 'Bangladesh Affairs',
        'title': 'National Flower of Bangladesh',
        'body': 'The national flower of Bangladesh is the Water Lily (Nymphaea nouchali). It was declared as the national flower after independence in 1971. Water lilies usually bloom in bills, ponds, and water bodies. It is a unique beauty of the nature of Bengal.',
        'keyPoint': 'Water Lily = National Flower',
        'isRead': 0,
      },
      {
        'groupId': 2,
        'languageCode': 'bn',
        'category': 'বিজ্ঞান ও প্রযুক্তি',
        'title': 'আলোর গতিবেগ',
        'body': 'শূন্য মাধ্যমে আলোর গতিবেগ প্রতি সেকেন্ডে প্রায় ৩,০০,০০০ কিলোমিটার (২৯৯,৭৯২,৪৫৮ মিটার/সেকেন্ড)। এটি মহাবিশ্বের সর্বোচ্চ গতিবেগ। আইনস্টাইনের আপেক্ষিক তত্ত্ব অনুযায়ী, কোনো বস্তুই আলোর গতিবেগ অতিক্রম করতে পারে না।',
        'keyPoint': 'আলোর গতি = ৩ লক্ষ কিমি/সে',
        'isRead': 0,
      },
      {
        'groupId': 2,
        'languageCode': 'en',
        'category': 'Science & Technology',
        'title': 'Speed of Light',
        'body': 'The speed of light in a vacuum is approximately 300,000 kilometers per second (299,792,458 meters per second). It is the maximum speed in the universe. According to Einstein\\'s theory of relativity, no object can exceed the speed of light.',
        'keyPoint': 'Speed of light = 300,000 km/s',
        'isRead': 0,
      },
      {
        'groupId': 3,
        'languageCode': 'bn',
        'category': 'ইতিহাস',
        'title': 'মুক্তিযুদ্ধের ইতিহাস',
        'body': 'বাংলাদেশের মুক্তিযুদ্ধ ১৯৭১ সালে সংঘটিত হয়। পাকিস্তানি হানাদার বাহিনীর বিরুদ্ধে দীর্ঘ ৯ মাস রক্তক্ষয়ী যুদ্ধের পর ১৯৭১ সালের ১৬ ডিসেম্বর বাংলাদেশ বিজয় লাভ করে। এই যুদ্ধে প্রায় ৩০ লক্ষ মানুষ শহীদ হন।',
        'keyPoint': 'মুক্তিযুদ্ধ = ১৯৭১',
        'isRead': 0,
      },
      {
        'groupId': 3,
        'languageCode': 'en',
        'category': 'History',
        'title': 'History of the Liberation War',
        'body': 'The Liberation War of Bangladesh took place in 1971. After a bloody 9-month war against the Pakistani occupation forces, Bangladesh achieved victory on December 16, 1971. About 3 million people were martyred in this war.',
        'keyPoint': 'Liberation War = 1971',
        'isRead': 0,
      },
      {
        'groupId': 4,
        'languageCode': 'bn',
        'category': 'ভূগোল',
        'title': 'বাংলাদেশের ভৌগোলিক অবস্থান',
        'body': 'বাংলাদেশ দক্ষিণ এশিয়ায় অবস্থিত। এর উত্তরে ভারতের মেঘালয় রাজ্য, পূর্বে ভারতের আসাম ও ত্রিপুরা, পশ্চিমে পশ্চিমবঙ্গ এবং দক্ষিণে বঙ্গোপসাগর। বাংলাদেশের মোট আয়তন ১,৪৭,৫৭০ বর্গকিলোমিটার।',
        'keyPoint': 'আয়তন = ১,৪৭,৫৭০ বর্গকিমি',
        'isRead': 0,
      },
      {
        'groupId': 4,
        'languageCode': 'en',
        'category': 'Geography',
        'title': 'Geographical Location of Bangladesh',
        'body': 'Bangladesh is located in South Asia. It is bordered by the Indian states of Meghalaya to the north, Assam and Tripura to the east, West Bengal to the west, and the Bay of Bengal to the south. The total area of Bangladesh is 147,570 square kilometers.',
        'keyPoint': 'Area = 147,570 sq km',
        'isRead': 0,
      },
      {
        'groupId': 5,
        'languageCode': 'bn',
        'category': 'খেলাধুলা',
        'title': 'ক্রিকেটে বাংলাদেশের প্রথম টেস্ট জয়',
        'body': 'বাংলাদেশ ক্রিকেট দল তাদের প্রথম টেস্ট ম্যাচ জয়লাভ করে ২০০৫ সালে। জিম্বাবুয়ের বিপক্ষে অনুষ্ঠিত সেই ম্যাচে বাংলাদেশ ২২৬ রানে জয়লাভ করে। এটি ছিল বাংলাদেশ ক্রিকেটের ইতিহাসে একটি মাইলফলক।',
        'keyPoint': 'প্রথম টেস্ট জয় = ২০০৫',
        'isRead': 0,
      },
      {
        'groupId': 5,
        'languageCode': 'en',
        'category': 'Sports',
        'title': 'Bangladesh\\'s First Test Win in Cricket',
        'body': 'The Bangladesh cricket team won their first Test match in 2005. In that match against Zimbabwe, Bangladesh won by 226 runs. It was a milestone in the history of Bangladesh cricket.',
        'keyPoint': 'First Test Win = 2005',
        'isRead': 0,
      },
      {
        'groupId': 6,
        'languageCode': 'bn',
        'category': 'সাহিত্য ও সংস্কৃতি',
        'title': 'রবীন্দ্রনাথ ঠাকুর',
        'body': 'রবীন্দ্রনাথ ঠাকুর ছিলেন একজন বাঙালি polymath, কবি, দার্শনিক এবং চিত্রশিল্পী। তিনি ১৯১৩ সালে সাহিত্যে নোবেল পুরস্কার লাভ করেন। তার বিখ্যাত কাব্যগ্রন্থ "গীতাঞ্জলি"। তিনি বাংলাদেশ ও ভারতের জাতীয় সঙ্গীতের রচয়িতা।',
        'keyPoint': 'নোবেল পুরস্কার = ১৯১৩',
        'isRead': 0,
      },
      {
        'groupId': 6,
        'languageCode': 'en',
        'category': 'Literature & Culture',
        'title': 'Rabindranath Tagore',
        'body': 'Rabindranath Tagore was a Bengali polymath, poet, philosopher, and painter. He won the Nobel Prize in Literature in 1913. His famous poetry collection is "Gitanjali". He is the composer of the national anthems of both Bangladesh and India.',
        'keyPoint': 'Nobel Prize = 1913',
        'isRead': 0,
      },
      {
        'groupId': 7,
        'languageCode': 'bn',
        'category': 'কম্পিউটার ও ডিজিটাল জ্ঞান',
        'title': 'কম্পিউটারের জনক',
        'body': 'চার্লস ব্যাবেজকে কম্পিউটারের জনক বলা হয়। তিনি প্রথম যান্ত্রিক কম্পিউটার "অ্যানালিটিক্যাল ইঞ্জিন" ডিজাইন করেন। তার ধারণার ভিত্তিতেই আধুনিক কম্পিউটার তৈরি হয়েছে।',
        'keyPoint': 'কম্পিউটারের জনক = চার্লস ব্যাবেজ',
        'isRead': 0,
      },
      {
        'groupId': 7,
        'languageCode': 'en',
        'category': 'Computer & Digital Knowledge',
        'title': 'Father of Computer',
        'body': 'Charles Babbage is known as the father of the computer. He designed the first mechanical computer, the "Analytical Engine". Modern computers are built based on his ideas.',
        'keyPoint': 'Father of Computer = Charles Babbage',
        'isRead': 0,
      },
      {
        'groupId': 8,
        'languageCode': 'bn',
        'category': 'স্বাস্থ্য ও দৈনন্দিন বিজ্ঞান',
        'title': 'পানির 중요성',
        'body': 'মানবদেহের প্রায় ৬০% পানি। প্রতিদিন পর্যাপ্ত পানি পান করা স্বাস্থ্যের জন্য অত্যন্ত জরুরি। পানি শরীরের তাপমাত্রা নিয়ন্ত্রণ করে, বর্জ্য বের করে এবং অঙ্গগুলোকে সচল রাখে। প্রতিদিন কমপক্ষে ৮ গ্লাস পানি পান করা উচিত।',
        'keyPoint': 'প্রতিদিন ৮ গ্লাস পানি',
        'isRead': 0,
      },
      {
        'groupId': 8,
        'languageCode': 'en',
        'category': 'Health & Daily Science',
        'title': 'Importance of Water',
        'body': 'About 60% of the human body is water. Drinking enough water daily is crucial for health. Water regulates body temperature, flushes out waste, and keeps organs functioning. You should drink at least 8 glasses of water every day.',
        'keyPoint': '8 glasses of water daily',
        'isRead': 0,
      },
    ];

    for (var item in data) {
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
