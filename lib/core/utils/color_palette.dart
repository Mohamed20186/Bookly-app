import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  // Brand Colors
  static const Color ceriseRed = Color(0xFFE94560);
  static const Color royalPurple = Color(0xFF533483);

  static const Color background = Color(0xFF0F0E17);
  static const Color surface = Color(0xFF1A1826);
  static const Color cardBg = Color(0xFF201E2E);
  static const Color gold = Color(0xFFE8B84B);
  static const Color goldLight = Color(0xFFF5D07A);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color textPrimary = Color(0xFFF5F0E8);
  static const Color textSecondary = Color(0xFF9E99B0);
  static const Color divider = Color(0xFF2E2B3D);

  static const String fontDisplay = 'Georgia';

  // Background Gradient
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color backgroundMid = Color(0xFF16213E);
  static const Color backgroundDeep = Color(0xFF0F3460);

  // Text Colors
  static const Color slateGray = Color(0xFF6B7280);
  static const Color silverMist = Color(0xFFB0B8C1);

  // Gradient shortcut
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundDark, backgroundMid, backgroundDeep],
  );

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [royalPurple, ceriseRed],
  );

  static const LinearGradient loadingBarGradient = LinearGradient(
    colors: [royalPurple, ceriseRed],
  );
}


class BookTheme {
  static const Color background = Color(0xFF0F0E17);
  static const Color surface = Color(0xFF1A1826);
  static const Color cardBg = Color(0xFF201E2E);
  static const Color gold = Color(0xFFE8B84B);
  static const Color goldLight = Color(0xFFF5D07A);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color textPrimary = Color(0xFFF5F0E8);
  static const Color textSecondary = Color(0xFF9E99B0);
  static const Color divider = Color(0xFF2E2B3D);

  static const String fontDisplay = 'Georgia'; // elegant serif for titles
}