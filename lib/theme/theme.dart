import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YangjiColors {
  // Brand
  static const primary = Color(0xFF2FA596);
  static const primaryDark = Color(0xFF214A5B);
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);

  // Status
  static const up = Color(0xFFE53935);
  static const down = Color(0xFF1E88E5);
  static const newTag = Color(0xFF43A047);
  static const neutral = Color(0xFF9E9E9E);

  // Tag Categories
  static const politics = Color(0xFF2FA596);
  static const economy = Color(0xFF5AA9E6);
  static const diplomacy = Color(0xFFB38DDB);
  static const society = Color(0xFFF4B183);

  // Text
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textHint = Color(0xFFBDBDBD);
}

class YangjiTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: YangjiColors.primary,
        background: YangjiColors.background,
        surface: YangjiColors.surface,
      ),
      scaffoldBackgroundColor: YangjiColors.background,
      textTheme: GoogleFonts.notoSansKrTextTheme().copyWith(
        displayLarge: GoogleFonts.notoSansKr(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: YangjiColors.textPrimary,
        ),
        titleLarge: GoogleFonts.notoSansKr(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: YangjiColors.textPrimary,
        ),
        titleMedium: GoogleFonts.notoSansKr(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: YangjiColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.notoSansKr(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: YangjiColors.textPrimary,
        ),
        bodySmall: GoogleFonts.notoSansKr(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: YangjiColors.textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: YangjiColors.surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: YangjiColors.primaryDark),
        titleTextStyle: GoogleFonts.notoSansKr(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: YangjiColors.primaryDark,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: YangjiColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: YangjiColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: YangjiColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
