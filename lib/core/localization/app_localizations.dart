import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('bn'),
    Locale('en'),
  ];

  String get appName => _getTranslation('app_name');

  String _getTranslation(String key) {
    if (locale.languageCode == 'en') {
      return _en[key] ?? key;
    }
    return _bn[key] ?? key;
  }

  static final Map<String, String> _bn = {
    'app_name': 'MyWork',
    'home': 'হোম',
    'ledger': 'হিসাব',
    'games': 'গেমস',
    'health': 'স্বাস্থ্য',
    'knowledge': 'জ্ঞান',
    'settings': 'সেটিংস',
    'language': 'ভাষা',
    'income': 'আয়',
    'expense': 'ব্যয়',
    'balance': 'ব্যালেন্স',
    'add_transaction': 'নতুন লেনদেন',
    'save': 'সংরক্ষণ করুন',
    'cancel': 'বাতিল',
    'delete': 'মুছে ফেলুন',
    'are_you_sure': 'আপনি কি নিশ্চিত?',
    'yes': 'হ্যাঁ',
    'no': 'না',
    'recent_transactions': 'সাম্প্রতিক লেনদেন',
    'no_transactions': 'কোনো লেনদেন নেই',
    'start_quiz': 'কুইজ শুরু করুন',
    'quiz_setup': 'কুইজ সেটআপ',
    'select_category': 'ক্যাটাগরি নির্বাচন করুন',
    'number_of_questions': 'প্রশ্নের সংখ্যা',
    'results': 'ফলাফল',
    'score': 'স্কোর',
    'correct': 'সঠিক',
    'wrong': 'ভুল',
    'accuracy': 'সঠিকতা',
    'average_time': 'গড় সময়',
    'fastest_correct': 'দ্রুততম সঠিক',
    'back': 'ফিরে যান',
    'next_question': 'পরবর্তী প্রশ্ন',
    'see_results': 'ফলাফল দেখুন',
    'time_left': 'সময় বাকি',
  };

  static final Map<String, String> _en = {
    'app_name': 'MyWork',
    'home': 'Home',
    'ledger': 'Ledger',
    'games': 'Games',
    'health': 'Health',
    'knowledge': 'Knowledge',
    'settings': 'Settings',
    'language': 'Language',
    'income': 'Income',
    'expense': 'Expense',
    'balance': 'Balance',
    'add_transaction': 'Add Transaction',
    'save': 'Save',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'are_you_sure': 'Are you sure?',
    'yes': 'Yes',
    'no': 'No',
    'recent_transactions': 'Recent Transactions',
    'no_transactions': 'No transactions yet',
    'start_quiz': 'Start Quiz',
    'quiz_setup': 'Quiz Setup',
    'select_category': 'Select Category',
    'number_of_questions': 'Number of Questions',
    'results': 'Results',
    'score': 'Score',
    'correct': 'Correct',
    'wrong': 'Wrong',
    'accuracy': 'Accuracy',
    'average_time': 'Average Time',
    'fastest_correct': 'Fastest Correct',
    'back': 'Back',
    'next_question': 'Next Question',
    'see_results': 'See Results',
    'time_left': 'Time Left',
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['bn', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
