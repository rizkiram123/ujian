import 'dart:async';
import 'package:flutter/material.dart';
import '../data/quiz_dataset.dart';
import '../models/quiz_question.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_button.dart';
import '../widgets/neumorphic_card.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;
  final bool isDarkMode;

  const QuizScreen({
    super.key,
    required this.category,
    required this.isDarkMode,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  int _score = 0;
  int _streak = 0;
  int _lives = 3;
  int _timeLeft = 15;
  Timer? _timer;
  
  // Hint states
  Set<int> _disabledOptions = {};
  bool _hintUsed5050 = false;
  bool _showSentenceHint = false;

  // Answer History tracking
  final List<Map<String, dynamic>> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    _questions = QuizDataset.getQuestionsForCategory(widget.category.id);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = 15;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _onTimeOut();
      }
    });
  }

  void _onTimeOut() {
    if (_isAnswered) return;

    final currentQuestion = _questions[_currentIndex];
    setState(() {
      _isAnswered = true;
      _selectedAnswerIndex = -1; // Time out
      _streak = 0;
      _lives--;

      _userAnswers.add({
        'question': currentQuestion,
        'selectedIndex': -1,
        'isCorrect': false,
        'isTimeOut': true,
      });
    });
  }

  void _selectAnswer(int optionIndex) {
    if (_isAnswered || _disabledOptions.contains(optionIndex)) return;

    _timer?.cancel();
    final currentQuestion = _questions[_currentIndex];
    final isCorrect = optionIndex == currentQuestion.correctIndex;

    setState(() {
      _selectedAnswerIndex = optionIndex;
      _isAnswered = true;

      if (isCorrect) {
        _streak++;
        final bonus = (_streak > 1) ? (_streak * 20) : 0;
        _score += 100 + bonus;
      } else {
        _streak = 0;
        _lives--;
      }

      _userAnswers.add({
        'question': currentQuestion,
        'selectedIndex': optionIndex,
        'isCorrect': isCorrect,
        'isTimeOut': false,
      });
    });
  }

  void _use5050Hint() {
    if (_hintUsed5050 || _isAnswered) return;

    final currentQuestion = _questions[_currentIndex];
    final correctIndex = currentQuestion.correctIndex;
    final List<int> wrongIndices = [];

    for (int i = 0; i < currentQuestion.options.length; i++) {
      if (i != correctIndex) {
        wrongIndices.add(i);
      }
    }
    wrongIndices.shuffle();

    setState(() {
      _disabledOptions.add(wrongIndices[0]);
      _disabledOptions.add(wrongIndices[1]);
      _hintUsed5050 = true;
    });
  }

  void _nextQuestion() {
    if (_lives <= 0 || _currentIndex >= _questions.length - 1) {
      _finishQuiz();
      return;
    }

    setState(() {
      _currentIndex++;
      _selectedAnswerIndex = null;
      _isAnswered = false;
      _disabledOptions.clear();
      _showSentenceHint = false;
    });

    _startTimer();
  }

  void _finishQuiz() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          category: widget.category,
          score: _score,
          userAnswers: _userAnswers,
          totalQuestions: _questions.length,
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    final currentQuestion = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NeumorphicIconButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDarkMode ? NeumorphicColors.darkBg : NeumorphicColors.lightBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isDarkMode ? NeumorphicColors.darkShadowDark : NeumorphicColors.lightShadowDark).withOpacity(0.4),
                          offset: const Offset(3, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      'Soal ${_currentIndex + 1} / ${_questions.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                      ),
                    ),
                  ),
                  // Lives Display
                  Row(
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          index < _lives ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: index < _lives ? NeumorphicColors.error : (isDarkMode ? Colors.white24 : Colors.black26),
                          size: 22,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Progress & Stats Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Streak Badge
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Streak: $_streak',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  // Animated Timer Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _timeLeft <= 5 ? NeumorphicColors.error.withOpacity(0.15) : NeumorphicColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: _timeLeft <= 5 ? NeumorphicColors.error : NeumorphicColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_timeLeft}s',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _timeLeft <= 5 ? NeumorphicColors.error : NeumorphicColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Score Counter
                  Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Skor: $_score',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Timer Progress Line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _timeLeft / 15.0,
                  minHeight: 6,
                  backgroundColor: isDarkMode ? Colors.white10 : Colors.black12,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _timeLeft <= 5 ? NeumorphicColors.error : NeumorphicColors.primary,
                  ),
                ),
              ),
            ),

            // Scrollable Content area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    // Main Question Card (Neumorphic)
                    NeumorphicCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: NeumorphicColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  currentQuestion.partOfSpeech,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: NeumorphicColors.primary,
                                  ),
                                ),
                              ),
                              // 50:50 Lifeline Button
                              IconButton(
                                icon: Icon(
                                  Icons.filter_2_rounded,
                                  color: _hintUsed5050 ? Colors.grey : NeumorphicColors.primary,
                                  size: 22,
                                ),
                                tooltip: 'Bantuan 50:50',
                                onPressed: _hintUsed5050 || _isAnswered ? null : _use5050Hint,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Cari Sinonim Kata:',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode ? Colors.white60 : NeumorphicColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentQuestion.word,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Sentence Hint Button & Card
                          if (!_showSentenceHint)
                            InkWell(
                              onTap: () => setState(() => _showSentenceHint = true),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber),
                                  SizedBox(width: 6),
                                  Text(
                                    'Lihat Contoh Kalimat',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.amber.withOpacity(0.3)),
                              ),
                              child: Text(
                                '"${currentQuestion.sentenceExample}"',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: isDarkMode ? Colors.amber.shade200 : Colors.amber.shade900,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Option Buttons (4 options)
                    ...List.generate(currentQuestion.options.length, (index) {
                      final optionText = currentQuestion.options[index];
                      final optionLetters = ['A', 'B', 'C', 'D'];
                      final isDisabled = _disabledOptions.contains(index);

                      bool isCorrectChoice = index == currentQuestion.correctIndex;
                      bool isUserChoice = index == _selectedAnswerIndex;

                      Color? customBg;
                      Border? customBorder;

                      if (_isAnswered) {
                        if (isCorrectChoice) {
                          customBg = NeumorphicColors.success.withOpacity(isDarkMode ? 0.25 : 0.15);
                          customBorder = Border.all(color: NeumorphicColors.success, width: 2);
                        } else if (isUserChoice) {
                          customBg = NeumorphicColors.error.withOpacity(isDarkMode ? 0.25 : 0.15);
                          customBorder = Border.all(color: NeumorphicColors.error, width: 2);
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isDisabled ? 0.35 : 1.0,
                          child: NeumorphicCard(
                            borderRadius: 18,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            backgroundColor: customBg,
                            border: customBorder,
                            onTap: isDisabled ? null : () => _selectAnswer(index),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: _isAnswered && isCorrectChoice
                                        ? NeumorphicColors.success
                                        : (_isAnswered && isUserChoice
                                            ? NeumorphicColors.error
                                            : NeumorphicColors.primary.withOpacity(0.12)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: _isAnswered && isCorrectChoice
                                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                                        : (_isAnswered && isUserChoice
                                            ? const Icon(Icons.close, color: Colors.white, size: 20)
                                            : Text(
                                                optionLetters[index],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: NeumorphicColors.primary,
                                                ),
                                              )),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Explanation Box after Answer
                    if (_isAnswered) ...[
                      const SizedBox(height: 12),
                      NeumorphicCard(
                        borderRadius: 18,
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _selectedAnswerIndex == currentQuestion.correctIndex
                                      ? Icons.check_circle_rounded
                                      : Icons.info_rounded,
                                  color: _selectedAnswerIndex == currentQuestion.correctIndex
                                      ? NeumorphicColors.success
                                      : NeumorphicColors.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedAnswerIndex == currentQuestion.correctIndex
                                      ? 'Jawaban Benar! (+100)'
                                      : (_selectedAnswerIndex == -1 ? 'Waktu Habis!' : 'Jawaban Kurang Tepat'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: _selectedAnswerIndex == currentQuestion.correctIndex
                                        ? NeumorphicColors.success
                                        : NeumorphicColors.error,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentQuestion.explanation,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: isDarkMode ? Colors.white70 : NeumorphicColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      NeumorphicButton(
                        isPrimary: true,
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        onPressed: _nextQuestion,
                        icon: Icons.arrow_forward_rounded,
                        child: Text(
                          _currentIndex < _questions.length - 1 ? 'Kata Selanjutnya' : 'Lihat Hasil Kuis',
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
