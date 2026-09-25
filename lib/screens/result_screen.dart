import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_button.dart';
import '../widgets/neumorphic_card.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final QuizCategory category;
  final int score;
  final List<Map<String, dynamic>> userAnswers;
  final int totalQuestions;
  final bool isDarkMode;

  const ResultScreen({
    super.key,
    required this.category,
    required this.score,
    required this.userAnswers,
    required this.totalQuestions,
    required this.isDarkMode,
  });

  int get correctCount => userAnswers.where((a) => a['isCorrect'] == true).length;
  double get accuracy => totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0;

  String get badgeTitle {
    if (accuracy >= 90) return '🏆 Master Sinonim';
    if (accuracy >= 70) return '🌟 Kamus Berjalan';
    if (accuracy >= 50) return '👍 Pelajar Handal';
    return '📚 Terus Berlatih';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NeumorphicIconButton(
                    icon: Icons.home_rounded,
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    tooltip: 'Beranda',
                  ),
                  Text(
                    'Hasil Kuis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance spacing
                ],
              ),

              const SizedBox(height: 24),

              // Main Score Card (Neumorphic Gauge)
              NeumorphicCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    // Badge Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: NeumorphicColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: NeumorphicColors.primary.withOpacity(0.4)),
                      ),
                      child: Text(
                        badgeTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: NeumorphicColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Circular Progress Dial
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: CircularProgressIndicator(
                            value: accuracy / 100,
                            strokeWidth: 12,
                            backgroundColor: isDarkMode ? Colors.white10 : Colors.black12,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              accuracy >= 70 ? NeumorphicColors.success : NeumorphicColors.primary,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${accuracy.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                              ),
                            ),
                            Text(
                              'Akurasi',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode ? Colors.white60 : NeumorphicColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Total Skor: $score Poin',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: NeumorphicColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Berhasil menjawab $correctCount dari $totalQuestions soal kata dengan benar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white70 : NeumorphicColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: NeumorphicButton(
                      borderRadius: 16,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              category: category,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        );
                      },
                      icon: Icons.refresh_rounded,
                      child: const Text('Coba Lagi'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: NeumorphicButton(
                      isPrimary: true,
                      borderRadius: 16,
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      icon: Icons.category_rounded,
                      child: const Text('Kategori'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Section Header: Answer Review
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Evaluasi Kosa Kata',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Review List
              ...List.generate(userAnswers.length, (index) {
                final item = userAnswers[index];
                final QuizQuestion question = item['question'];
                final bool isCorrect = item['isCorrect'];
                final int selectedIndex = item['selectedIndex'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NeumorphicCard(
                    borderRadius: 16,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                              color: isCorrect ? NeumorphicColors.success : NeumorphicColors.error,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              question.word,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              question.partOfSpeech,
                              style: const TextStyle(
                                fontSize: 12,
                                color: NeumorphicColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Sinonim Tepat: ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white70 : NeumorphicColors.textDark,
                              ),
                            ),
                            Text(
                              question.correctAnswer,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: NeumorphicColors.success,
                              ),
                            ),
                          ],
                        ),
                        if (!isCorrect && selectedIndex >= 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Pilihan Anda: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDarkMode ? Colors.white60 : NeumorphicColors.textMuted,
                                ),
                              ),
                              Text(
                                question.options[selectedIndex],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: NeumorphicColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          question.explanation,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.white54 : NeumorphicColors.textMuted,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
