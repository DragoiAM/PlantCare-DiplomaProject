import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:test_project/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  final String _boxName = 'settingsBox';
  final String _key = 'isDarkMode';

  ThemeProvider() : _themeData = lightMode {
    loadThemeMode();
  }

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      saveThemeChoice(true);
    } else {
      themeData = lightMode;
      saveThemeChoice(false);
    }
  }

  Future<void> saveThemeChoice(bool isDarkMode) async {
    var box = await Hive.openBox(_boxName);
    box.put(_key, isDarkMode);
  }

  Future<void> loadThemeMode() async {
    var box = await Hive.openBox('settingsBox');
    bool isDarkMode = box.get('isDarkMode', defaultValue: false);
    _themeData = isDarkMode ? darkMode : lightMode;
    notifyListeners(); // This is crucial to update listeners after theme is determined.
  }
}
