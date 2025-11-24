app colors

import 'package:flutter/material.dart';

class AppColors {
  // ========================= PRIMARY COLORS =========================
  static const Color primary = Color(0xFF007AFF);       // iOS Blue
  static const Color primaryLight = Color(0xFF5AC8FA);  // Aqua Blue
  static const Color primaryDark = Color(0xFF0051D5);   // Deep Blue

  // ========================= SECONDARY COLORS =========================
  static const Color secondary = Color(0xFF5856D6);     // Purple
  static const Color accent = Color(0xFFFF9500);        // Orange

  // ========================= STATUS COLORS =========================
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF007AFF);

  // ========================= LIGHT THEME COLORS =========================
  static const Color background = Color(0xFFF2F2F7);         // Page background
  static const Color surface = Color(0xFFFFFFFF);            // Card / container
  static const Color surfaceVariant = Color(0xFFF2F2F7);
  static const Color inputFillColor = Color(0xFFF9F9F9);

  // Text
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFFC7C7CC);

  // Divider / Border
  static const Color separator = Color(0xFFC6C6C8);
  static const Color separatorLight = Color(0xFFE5E5EA);

  // Card
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E5EA);

  // Shadows
  static const Color shadowColor = Color(0x1A000000); // 10% black shadow

  // ========================= GRADIENTS =========================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF5856D6), Color(0xFFAF52DE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ========================= DARK THEME COLORS =========================
  static const Color darkBackground = Color(0xFF000000);      // Full black
  static const Color darkSurface = Color(0xFF1C1C1E);         // iOS dark card
  static const Color darkSurfaceVariant = Color(0xFF2C2C2E);

  // Dark theme text
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF8E8E93);
  static const Color darkTextTertiary = Color(0xFF636366);

  // Divider dark
  static const Color darkSeparator = Color(0xFF38383A);
  static const Color darkSeparatorLight = Color(0xFF2C2C2E);

  // Dark theme card
  static const Color darkCardBackground = Color(0xFF1C1C1E);
  static const Color darkCardBorder = Color(0xFF38383A);
}