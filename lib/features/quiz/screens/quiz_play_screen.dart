import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/question_model.dart';
import '../data/quiz_repository.dart';
import '../data/quiz_answer_repository.dart';
import 'quiz_result_screen.dart';

class QuizPlayScreen extends StatefulWidget {
  final List<QuestionModel> questions;
  final String category;

  const QuizPlayScreen({
    super.key,
    required this.questions,
    required this.category,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  double _totalScore = 0;
  int _totalTimeNs = 0;
  int _fastestCorrectNs = 9999999999999;
  
  int? _selectedOption;
  bool _isAnswered = false;
  bool _isSaving = false;

  Timer? _timer;
  int _timeLeft = 20;
  final int _maxTime = 20;
  
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = _maxTime;
    _isAnswered = false;
    _selectedOption = null;
    _stopwatch = Stopwatch()..start();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _handleTimeout();
        }
      });
    });
  }

  void _handleTimeout() {
    _stopwatch.stop();
    final timeTakenNs = _maxTime * 1000000000;
    _totalTimeNs += timeTakenNs;
    
    setState(() {
      _isAnswered = true;
      _selectedOption = -1;
      _wrongCount++;
    });
    _saveAnswer(-1, false, timeTakenNs, 0);
  }

  void _handleOptionSelect(int index) {
    if (_isAnswered) return;
    
    _stopwatch.stop();
    _timer?.cancel();
    
    final timeTakenNs = (_stopwatch.elapsedMicroseconds * 1000);
    _totalTimeNs += timeTakenNs;

    final question = widget.questions[_currentIndex];
    final isCorrect = index == question.correctOptionIndex;
    double pointsEarned = 0;

    setState(() {
      _selectedOption = index;
      _isAnswered = true;

      if (isCorrect) {
        _correctCount++;
        if (timeTakenNs < _fastestCorrectNs) {
          _fastestCorrectNs = timeTakenNs;
        }
        
        final remainingRatio = (_maxTime - (timeTakenNs / 1000000000)) / _maxTime;
        final speedPoints = 30 * (remainingRatio > 0 ? remainingRatio : 0);
        pointsEarned = 70 + speedPoints;
        _totalScore += pointsEarned;
      } else {
        _wrongCount++;
      }
    });

    _saveAnswer(index, isCorrect, timeTakenNs, pointsEarned);
  }

  Future<void> _saveAnswer(int selected, bool isCorrect, int timeNs, double points) async {
    if (widget.questions[_currentIndex].id == null) return;
    await QuizAnswerRepository().saveAnswer(
      quizResultId: 0, // Temporary, will update on finish
      questionGroupId: widget.questions[_currentIndex].id!,
      selectedOption: selected,
      isCorrect: isCorrect,
      timeTakenNs: timeNs,
      pointsEarned: points,
    );
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _startTimer();
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final totalQ = widget.questions.length;
    final accuracy = (_correctCount / totalQ) * 100;
    final maxScore = totalQ * 100.0;
    final avgTimeNs = _totalTimeNs ~/ totalQ;
    
    String grade = 'E';
    final scorePercent = (_totalScore / maxScore) * 100;
    if (scorePercent >= 90) grade = 'S';
    else if (scorePercent >= 80) grade = 'A';
    else if (scorePercent >= 70) grade = 'B';
    else if (scorePercent >= 60) grade = 'C';
    else if (scorePercent >= 50) grade = 'D';

    final resultId = await QuizRepository().saveQuizResultAndGetId(
      category: widget.category,
      totalQuestions: totalQ,
      correctAnswers: _correctCount,
      wrongAnswers: _wrongCount,
      accuracyPercent: accuracy,
      totalScore: _totalScore,
      maxPossibleScore: maxScore,
      averageTimeNs: avgTimeNs,
      fastestCorrectNs: _fastestCorrectNs == 9999999999999 ? 0 : _fastestCorrectNs,
      grade: grade,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            resultId: resultId,
            category: widget.category,
            totalQuestions: totalQ,
            correctAnswers: _correctCount,
            wrongAnswers: _wrongCount,
            accuracyPercent: accuracy,
            totalScore: _totalScore,
            maxPossibleScore: maxScore,
            averageTimeNs: avgTimeNs,
            fastestCorrectNs: _fastestCorrectNs == 9999999999999 ? 0 : _fastestCorrectNs,
            grade: grade,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('প্রশ্ন ${_currentIndex + 1}/${widget.questions.length}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '$_timeLeft সে',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _timeLeft <= 5 ? AppColors.error : AppColors.primary,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: _timeLeft / _maxTime,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(
                _timeLeft <= 5 ? AppColors.error : AppColors.secondary,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 32),
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  Color bgColor = Colors.white;
                  Color borderColor = AppColors.divider;
                  Color textColor = AppColors.textPrimary;

                  if (_isAnswered) {
                    if (index == question.correctOptionIndex) {
                      bgColor = AppColors.success.withOpacity(0.1);
                      borderColor = AppColors.success;
                      textColor = AppColors.success;
                    } else if (index == _selectedOption) {
                      bgColor = AppColors.error.withOpacity(0.1);
                      borderColor = AppColors.error;
                      textColor = AppColors.error;
                    }
                  }

                  return GestureDetector(
                    onTap: () => _handleOptionSelect(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        border: Border.all(color: borderColor, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: borderColor),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isAnswered)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _currentIndex < widget.questions.length - 1 ? 'পরবর্তী প্রশ্ন' : 'ফলাফল দেখুন',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
