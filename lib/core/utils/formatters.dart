import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'bn_BD',
    symbol: '৳',
    decimalDigits: 2,
  );

  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'আজ';
    } else if (dateToCheck == yesterday) {
      return 'গতকাল';
    } else {
      return DateFormat('dd MMM yyyy', 'bn').format(date);
    }
  }

  static String formatTimeNs(int nanoseconds) {
    if (nanoseconds < 1000000) {
      return '${(nanoseconds / 1000).toStringAsFixed(0)} µs';
    } else if (nanoseconds < 1000000000) {
      return '${(nanoseconds / 1000000).toStringAsFixed(3)} ms';
    } else {
      return '${(nanoseconds / 1000000000).toStringAsFixed(3)} s';
    }
  }

  static String formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}
