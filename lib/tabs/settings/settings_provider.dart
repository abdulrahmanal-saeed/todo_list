import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode theme = ThemeMode.light;
  bool get isDark => theme == ThemeMode.dark;

  String get backgroundImagePath =>
      isDark ? 'assets/images/dark_bg.png' : 'assets/images/default_bg.png';

  String language = 'en';

  SharedPreferences? prefs;

  void changeThemeMode(ThemeMode selectedThemeMode) {
    theme = selectedThemeMode;
    setThemeToCache(selectedThemeMode);

    notifyListeners();
  }

  void changeLanguage(String selectedlanguage) {
    language = selectedlanguage;
    setLanguageToCache(selectedlanguage);
    notifyListeners();
  }

  Future setThemeToCache(ThemeMode themeMode) async {
    prefs = await SharedPreferences.getInstance();
    String themeName = themeMode == ThemeMode.light ? "Light" : "Dark";
    await prefs!.setString('theme', themeName);
  }

  Future<void> loadTheme() async {
    prefs = await SharedPreferences.getInstance();
    final String? themeName = prefs!.getString('theme');
    if (themeName != null) {
      theme = themeName == "Light" ? ThemeMode.light : ThemeMode.dark;
      notifyListeners();
    }
  }

  Future setLanguageToCache(String selectedLanguage) async {
    prefs = await SharedPreferences.getInstance();
    await prefs!.setString('language', selectedLanguage);
  }

  Future<void> loadLanguage() async {
    prefs = await SharedPreferences.getInstance();
    final String? storedLanguage = prefs!.getString('language');
    if (storedLanguage != null) {
      language = storedLanguage;
      notifyListeners();
    }
  }

  Future<void> loadSettings() async {
    await loadTheme();
    await loadLanguage();
  }
}
