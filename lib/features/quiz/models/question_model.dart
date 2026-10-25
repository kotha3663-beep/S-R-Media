class QuestionModel {
  final int? id;
  final int groupId;
  final String languageCode;
  final String category;
  final String difficulty;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  QuestionModel({
    this.id,
    required this.groupId,
    required this.languageCode,
    required this.category,
    required this.difficulty,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'languageCode': languageCode,
      'category': category,
      'difficulty': difficulty,
      'questionText': questionText,
      'options': options.join('|||'),
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'],
      groupId: map['groupId'] ?? 0,
      languageCode: map['languageCode'],
      category: map['category'],
      difficulty: map['difficulty'],
      questionText: map['questionText'],
      options: (map['options'] as String).split('|||'),
      correctOptionIndex: map['correctOptionIndex'],
      explanation: map['explanation'],
    );
  }
}
