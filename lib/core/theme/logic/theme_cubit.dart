import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void changeTheme() {
    switch (_themeMode.index) {
      case 0: // System
        Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness; // gets the current brightness (Theme)
        _themeMode = brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
        break;
      case 1: // Light
        _themeMode = ThemeMode.dark;
        break;
      case 2: // Dark
        _themeMode = ThemeMode.light;
        break;
    }
    emit(ThemeLoaded());
  }
}
