import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  late bool isDarkMode;

  ConfigProvider({required this.isDarkMode});

  changeTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
