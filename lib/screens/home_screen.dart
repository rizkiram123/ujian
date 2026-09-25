import 'package:flutter/material.dart';
import '../data/quiz_dataset.dart';
import '../models/quiz_question.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_button.dart';
import '../widgets/neumorphic_card.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final categories = QuizDataset.categories;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        NeumorphicCard(
                          borderRadius: 14,
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.auto_awesome,
                            color: NeumorphicColors.primary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Synonym Quiz',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Soft UI Neumorphism Edition',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode ? Colors.white60 : NeumorphicColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    NeumorphicIconButton(
                      icon: isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      iconColor: isDarkMode ? Colors.amber : NeumorphicColors.primary,
                      onPressed: onToggleTheme,
                      tooltip: 'Toggle Theme',
                    ),
                  ],
                ),
              ),
            ),

            // Hero Banner Card
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: NeumorphicCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: NeumorphicColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.bolt_rounded, color: NeumorphicColors.primary, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Kuis Harian',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: NeumorphicColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                              SizedBox(width: 4),
                              Text(
                                'Streak: 5 Hari',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Asah Kosa Kata & Sinonim!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pilih jawaban sinonim yang paling tepat untuk setiap kata. Dapatkan skor tertinggi dan buka badge prestasi!',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: isDarkMode ? Colors.white70 : NeumorphicColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Category Title Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih Kategori Kuis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                      ),
                    ),
                    Text(
                      '${categories.length} Modul',
                      style: const TextStyle(
                        fontSize: 13,
                        color: NeumorphicColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _CategoryCard(
                        category: category,
                        isDarkMode: isDarkMode,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(
                                category: category,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),

            // How to Play Tip Section
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              sliver: SliverToBoxAdapter(
                child: NeumorphicCard(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      NeumorphicCard(
                        borderRadius: 12,
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.lightbulb_outline_rounded, color: Colors.amber, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tips Kuis Neumorphism',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Gunakan tombol Bantuan 50:50 jika ragu. Setiap jawaban benar berturut-turut akan memberikan bonus Streak!',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode ? Colors.white60 : NeumorphicColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isDarkMode,
    required this.onTap,
  });

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'language':
        return Icons.language_rounded;
      default:
        return Icons.quiz_rounded;
    }
  }

  Color _getBadgeColor(String difficulty) {
    switch (difficulty) {
      case 'Pemula':
        return NeumorphicColors.success;
      case 'Menengah':
        return NeumorphicColors.primary;
      case 'Mahir':
        return NeumorphicColors.error;
      default:
        return NeumorphicColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getBadgeColor(category.difficulty);

    return NeumorphicCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  NeumorphicCard(
                    borderRadius: 14,
                    padding: const EdgeInsets.all(12),
                    child: Icon(_getIcon(category.iconName), color: NeumorphicColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : NeumorphicColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.quiz_outlined, size: 14, color: isDarkMode ? Colors.white54 : NeumorphicColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '${category.totalQuestions} Soal Kata',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white54 : NeumorphicColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: badgeColor.withOpacity(0.4)),
                ),
                child: Text(
                  category.difficulty,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            category.description,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.white70 : NeumorphicColors.textMuted,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NeumorphicButton(
                isPrimary: true,
                onPressed: onTap,
                borderRadius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                icon: Icons.play_arrow_rounded,
                child: const Text('Mulai Kuis'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
