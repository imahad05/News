import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier{
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get theme => _isDark ? ThemeData.dark() : ThemeData.light();

  void toggleTheme(){
    _isDark = !_isDark;
    notifyListeners();
  }
}