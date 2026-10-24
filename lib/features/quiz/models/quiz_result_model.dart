class QuizResultModel {
  final int? id;
  final String category;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double accuracyPercent;
  final double totalScore;
  final double maxPossibleScore;
  final int averageTimeNs;
  final int fastestCorrectNs;
  final String grade;
  final DateTime createdAt;

  QuizResultModel({
    this.id,
    required this.category,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.accuracyPercent,
    required this.totalScore,
    required this.maxPossibleScore,
    required this.averageTimeNs,
    required this.fastestCorrectNs,
    required this.grade,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'accuracyPercent': accuracyPercent,
      'totalScore': totalScore,
      'maxPossibleScore': maxPossibleScore,
      'averageTimeNs': averageTimeNs,
      'fastestCorrectNs': fastestCorrectNs,
      'grade': grade,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory QuizResultModel.fromMap(Map<String, dynamic> map) {
    return QuizResultModel(
      id: map['id'],
      category: map['category'],
      totalQuestions: map['totalQuestions'],
      correctAnswers: map['correctAnswers'],
      wrongAnswers: map['wrongAnswers'],
      accuracyPercent: (map['accuracyPercent'] as num).toDouble(),
      totalScore: (map['totalScore'] as num).toDouble(),
      maxPossibleScore: (map['maxPossibleScore'] as num).toDouble(),
      averageTimeNs: map['averageTimeNs'],
      fastestCorrectNs: map['fastestCorrectNs'],
      grade: map['grade'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
