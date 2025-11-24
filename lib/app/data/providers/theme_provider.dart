import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider {
  static const String keyTheme = "isDarkMode";

  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyTheme) ?? false;
  }

  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyTheme, isDark);
  }
}