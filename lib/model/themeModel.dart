import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDark = false;
  // ThemeData _currentTheme = ThemeData(
  //   fontFamily: "Poppins",
  //   colorScheme:
  //       ColorScheme.fromSeed(seedColor: Color.fromRGBO(245, 141, 116, 1)),
  //   // ColorScheme.fromSeed(seedColor: Color(0xff825353)),
  //   useMaterial3: true,
  // );
  ThemeData _currentTheme = ThemeData(
    fontFamily: "Poppins",
    primaryColor: Color.fromRGBO(245, 141, 116, 1),
    colorScheme:
        ColorScheme.fromSeed(seedColor: Color.fromRGBO(245, 141, 116, 1)),
    useMaterial3: true,
  );

  bool get isDark => _isDark;
  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _isDark = !_isDark;
    _currentTheme = _isDark ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  void updateTheme(Color primaryColor) {
    _currentTheme = ThemeData(
      fontFamily: "Poppins",
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      useMaterial3: true,
    );
    notifyListeners();
  }
}
