import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static const Color primaryLight = Color(0xFF5D9CEC);
  static const Color backgroundLight = Color(0xFFDFECDB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0x0ff00000);
  static const Color grey = Color(0xFF363636);
  static const Color green = Color(0xFF61E757);
  static const Color red = Color(0xFFEC4B4B);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryLight,
    scaffoldBackgroundColor: Colors.transparent,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: white,
      selectedItemColor: primaryLight,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: white,
        shape: CircleBorder(side: BorderSide(color: white, width: 4))),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
      titleSmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey),
      labelSmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 13, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: primaryLight)),
    switchTheme:
        const SwitchThemeData(thumbColor: WidgetStatePropertyAll(white)),
  );

  // Dark Theme
  static const Color primaryDark = Color(0xFF5D9CEC);
  static const Color backgroundDark = Color(0xFF141922);
  static const Color bottomNav = Color(0xFF141922);
  static const Color unselectedItemColor = Color(0xFFC8C9CB);
  static const Color darkDropDown = Color(0xFF060E1E);

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryDark,
    scaffoldBackgroundColor: Colors.transparent,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: bottomNav,
      selectedItemColor: primaryDark,
      unselectedItemColor: unselectedItemColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryDark,
        foregroundColor: white,
        shape:
            CircleBorder(side: BorderSide(color: Color(0xFF141922), width: 4))),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
      titleSmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
      labelSmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 13, color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: primaryDark)),
    switchTheme:
        const SwitchThemeData(thumbColor: WidgetStatePropertyAll(white)),
  );
}
