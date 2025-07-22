import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.accent,
    required this.scaffoldBackground,
    required this.cardBackground,
    required this.inputBackground,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.divider,
  });

  final Color primary;
  final Color accent;
  final Color scaffoldBackground;
  final Color cardBackground;
  final Color inputBackground;
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color divider;

  @override
  AppColors copyWith({
    Color? primary,
    Color? accent,
    Color? scaffoldBackground,
    Color? cardBackground,
    Color? inputBackground,
    Color? primaryText,
    Color? secondaryText,
    Color? tertiaryText,
    Color? divider,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      inputBackground: inputBackground ?? this.inputBackground,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertiaryText: tertiaryText ?? this.tertiaryText,
      divider: divider ?? this.divider,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      scaffoldBackground: Color.lerp(
        scaffoldBackground,
        other.scaffoldBackground,
        t,
      )!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      tertiaryText: Color.lerp(tertiaryText, other.tertiaryText, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

class AppTheme {
  static final AppColors _lightColors = AppColors(
    primary: const Color(0xFF6A85F1),
    accent: const Color(0xFF7F53AC),
    scaffoldBackground: const Color(0xFFF6F7FB),
    cardBackground: Colors.white,
    inputBackground: const Color(0xFFF3F6FA),
    primaryText: Colors.black,
    secondaryText: Colors.grey[700]!,
    tertiaryText: Colors.grey[600]!,
    divider: Colors.grey[300]!,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightColors.scaffoldBackground,
      extensions: <ThemeExtension<dynamic>>[_lightColors],
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: _lightColors.primaryText,
        ),
        titleMedium: TextStyle(color: _lightColors.secondaryText),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w600,
          color: _lightColors.primaryText,
        ),
        labelMedium: TextStyle(
          color: _lightColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightColors.inputBackground,
        prefixIconColor: _lightColors.tertiaryText,
        labelStyle: TextStyle(color: _lightColors.secondaryText),
        hintStyle: TextStyle(color: Colors.grey[400]),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            return Colors.transparent;
          }),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: _lightColors.divider,
        thickness: 1.0,
      ),
    );
  }

  // You can add a dark theme later
  static ThemeData get darkTheme => lightTheme; // Placeholder
}
