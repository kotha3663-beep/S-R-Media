enum Difficulty { easy, medium, hard }

class KnowledgeItem {
  final int? id;
  final String category;
  final String title;
  final String body;
  final String keyPoint;
  final Difficulty difficulty;
  final String languageCode;

  KnowledgeItem({
    this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.keyPoint,
    required this.difficulty,
    required this.languageCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'body': body,
      'key_point': keyPoint,
      'difficulty': difficulty.name,
      'language_code': languageCode,
    };
  }

  factory KnowledgeItem.fromMap(Map<String, dynamic> map) {
    return KnowledgeItem(
      id: map['id'],
      category: map['category'],
      title: map['title'],
      body: map['body'],
      keyPoint: map['key_point'],
      difficulty: Difficulty.values.firstWhere((e) => e.name == map['difficulty']),
      languageCode: map['language_code'],
    );
  }
}

class QuizQuestion {
  final int? id;
  final int knowledgeItemId;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String category;
  final Difficulty difficulty;

  QuizQuestion({
    this.id,
    required this.knowledgeItemId,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.category,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'knowledge_item_id': knowledgeItemId,
      'question_text': questionText,
      'options': options.join('||'),
      'correct_option_index': correctOptionIndex,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty.name,
    };
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      id: map['id'],
      knowledgeItemId: map['knowledge_item_id'],
      questionText: map['question_text'],
      options: (map['options'] as String).split('||'),
      correctOptionIndex: map['correct_option_index'],
      explanation: map['explanation'],
      category: map['category'],
      difficulty: Difficulty.values.firstWhere((e) => e.name == map['difficulty']),
    );
  }
}

class QuizAnswer {
  final int? id;
  final int quizResultId;
  final int questionId;
  final int selectedOption;
  final bool isCorrect;
  final int timeTakenNs;
  final double pointsEarned;
  final double speedPoints;

  QuizAnswer({
    this.id,
    required this.quizResultId,
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
    required this.timeTakenNs,
    required this.pointsEarned,
    required this.speedPoints,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quiz_result_id': quizResultId,
      'question_id': questionId,
      'selected_option': selectedOption,
      'is_correct': isCorrect ? 1 : 0,
      'time_taken_ns': timeTakenNs,
      'points_earned': pointsEarned,
      'speed_points': speedPoints,
    };
  }

  factory QuizAnswer.fromMap(Map<String, dynamic> map) {
    return QuizAnswer(
      id: map['id'],
      quizResultId: map['quiz_result_id'],
      questionId: map['question_id'],
      selectedOption: map['selected_option'],
      isCorrect: map['is_correct'] == 1,
      timeTakenNs: map['time_taken_ns'],
      pointsEarned: map['points_earned'],
      speedPoints: map['speed_points'],
    );
  }
}

class QuizResult {
  final int? id;
  final String category;
  final String quizType;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double accuracyPercent;
  final double totalScore;
  final double maxPossibleScore;
  final double scorePercent;
  final int totalTimeNs;
  final int averageTimeNs;
  final int fastestCorrectNs;
  final int slowestCorrectNs;
  final String grade;
  final bool timerEnabled;
  final int perQuestionTimeSec;
  final DateTime createdAt;

  QuizResult({
    this.id,
    required this.category,
    required this.quizType,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.accuracyPercent,
    required this.totalScore,
    required this.maxPossibleScore,
    required this.scorePercent,
    required this.totalTimeNs,
    required this.averageTimeNs,
    required this.fastestCorrectNs,
    required this.slowestCorrectNs,
    required this.grade,
    required this.timerEnabled,
    required this.perQuestionTimeSec,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'quiz_type': quizType,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'wrong_answers': wrongAnswers,
      'accuracy_percent': accuracyPercent,
      'total_score': totalScore,
      'max_possible_score': maxPossibleScore,
      'score_percent': scorePercent,
      'total_time_ns': totalTimeNs,
      'average_time_ns': averageTimeNs,
      'fastest_correct_ns': fastestCorrectNs,
      'slowest_correct_ns': slowestCorrectNs,
      'grade': grade,
      'timer_enabled': timerEnabled ? 1 : 0,
      'per_question_time_sec': perQuestionTimeSec,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      id: map['id'],
      category: map['category'],
      quizType: map['quiz_type'],
      totalQuestions: map['total_questions'],
      correctAnswers: map['correct_answers'],
      wrongAnswers: map['wrong_answers'],
      accuracyPercent: map['accuracy_percent'],
      totalScore: map['total_score'],
      maxPossibleScore: map['max_possible_score'],
      scorePercent: map['score_percent'],
      totalTimeNs: map['total_time_ns'],
      averageTimeNs: map['average_time_ns'],
      fastestCorrectNs: map['fastest_correct_ns'],
      slowestCorrectNs: map['slowest_correct_ns'],
      grade: map['grade'],
      timerEnabled: map['timer_enabled'] == 1,
      perQuestionTimeSec: map['per_question_time_sec'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
