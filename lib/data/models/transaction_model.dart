enum TransactionType { income, expense }

class TransactionModel {
  final int? id;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String note;

  TransactionModel({
    this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type.name,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: map['amount'],
      type: map['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      category: map['category'],
      date: DateTime.parse(map['date']),
      note: map['note'],
    );
  }
}
