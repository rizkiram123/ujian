import 'package:flutter/material.dart';

class NeumorphicColors {
  // Light Mode Colors (Matching Screenshot - Soft Blue Neumorphism)
  static const Color lightBg = Color(0xFFE2E8F0); // Soft Blue Gray
  static const Color lightSurface = Color(0xFFE2E8F0);
  static const Color lightShadowLight = Color(0xFFFFFFFF);
  static const Color lightShadowDark = Color(0xFFA6B4C9);
  
  // Dark Mode Neumorphic Colors
  static const Color darkBg = Color(0xFF1E222A);
  static const Color darkSurface = Color(0xFF1E222A);
  static const Color darkShadowLight = Color(0xFF2B303B);
  static const Color darkShadowDark = Color(0xFF13161C);

  // Accent Colors
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color accentCyan = Color(0xFF0EA5E9);
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color error = Color(0xFFEF4444); // Crimson
  static const Color warning = Color(0xFFF59E0B); // Amber
  
  // Text Colors
  static const Color textDark = Color(0xFF2D3748);
  static const Color textMuted = Color(0xFF718096);
  static const Color textLight = Color(0xFFF8FAFC);
}

class NeumorphicDecoration {
  // Soft UI Embossed Card Box Decoration
  static BoxDecoration flat({
    required bool isDarkMode,
    double borderRadius = 20.0,
    Color? customColor,
    Border? border,
  }) {
    final bg = customColor ?? (isDarkMode ? NeumorphicColors.darkBg : NeumorphicColors.lightBg);
    final lightShadow = isDarkMode ? NeumorphicColors.darkShadowLight : NeumorphicColors.lightShadowLight;
    final darkShadow = isDarkMode ? NeumorphicColors.darkShadowDark : NeumorphicColors.lightShadowDark;

    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(borderRadius),
      border: border,
      boxShadow: [
        BoxShadow(
          color: lightShadow.withOpacity(isDarkMode ? 0.4 : 0.9),
          offset: const Offset(-5, -5),
          blurRadius: 10,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: darkShadow.withOpacity(isDarkMode ? 0.7 : 0.6),
          offset: const Offset(5, 5),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    );
  }

  // Soft UI Pressed / Inset Shadow Box Decoration
  static BoxDecoration inset({
    required bool isDarkMode,
    double borderRadius = 20.0,
    Color? customColor,
  }) {
    final bg = customColor ?? (isDarkMode ? const Color(0xFF1A1D24) : const Color(0xFFD8E0EC));
    final darkShadow = isDarkMode ? Colors.black.withOpacity(0.5) : const Color(0xFF9AA8BC).withOpacity(0.6);

    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: darkShadow,
          offset: const Offset(2, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Soft UI Active State (Green for Correct, Red for Incorrect)
  static BoxDecoration feedback({
    required Color color,
    required bool isDarkMode,
    double borderRadius = 20.0,
  }) {
    return BoxDecoration(
      color: color.withOpacity(isDarkMode ? 0.25 : 0.15),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: color, width: 2.0),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    );
  }
}
