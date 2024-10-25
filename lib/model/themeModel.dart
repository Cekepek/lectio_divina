import 'package:flutter/material.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

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
    primaryColor: globals.colorTheme,
    colorScheme: ColorScheme.fromSeed(seedColor: globals.colorTheme),
    useMaterial3: true,
  );

  ThemeModel() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentTheme = ThemeData(
      fontFamily: "Poppins",
      primaryColor: Color(prefs.getInt('color') ?? globals.colorTheme.value),
      colorScheme: ColorScheme.fromSeed(
          seedColor: Color(prefs.getInt('color') ?? globals.colorTheme.value)),
      useMaterial3: true,
    );
    notifyListeners();
  }

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
