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
    required this.error,
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
  final Color error;

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
    Color? error,
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
      error: error ?? this.error,
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
      error: Color.lerp(error, other.error, t)!,
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
    error: const Color(0xFFEF4444),
  );

  static final AppColors _darkColors = AppColors(
    primary: const Color(0xFF6A85F1),
    accent: const Color(0xFF7F53AC),
    scaffoldBackground: const Color(0xFF121212),
    cardBackground: const Color(0xFF1E1E1E),
    inputBackground: const Color(0xFF2A2A2A),
    primaryText: Colors.white,
    secondaryText: Colors.grey[300]!,
    tertiaryText: Colors.grey[400]!,
    divider: Colors.grey[700]!,
    error: const Color(0xFFEF4444),
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

      dialogTheme: DialogThemeData(
        backgroundColor: _lightColors.cardBackground,
        titleTextStyle: TextStyle(
          color: _lightColors.primaryText,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        contentTextStyle: TextStyle(
          color: _lightColors.secondaryText,
          fontSize: 16,
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

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkColors.scaffoldBackground,
      extensions: <ThemeExtension<dynamic>>[_darkColors],
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: _darkColors.primaryText,
        ),
        titleMedium: TextStyle(color: _darkColors.secondaryText),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w600,
          color: _darkColors.primaryText,
        ),
        labelMedium: TextStyle(
          color: _darkColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: _darkColors.cardBackground,
        titleTextStyle: TextStyle(
          color: _darkColors.primaryText,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        contentTextStyle: TextStyle(
          color: _darkColors.secondaryText,
          fontSize: 16,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkColors.inputBackground,
        prefixIconColor: _darkColors.tertiaryText,
        labelStyle: TextStyle(color: _darkColors.secondaryText),
        hintStyle: TextStyle(color: Colors.grey[500]),
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
        color: _darkColors.divider,
        thickness: 1.0,
      ),
    );
  }
}
