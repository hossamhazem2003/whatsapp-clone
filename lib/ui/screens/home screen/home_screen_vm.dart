import 'package:flutter/material.dart';

class HomeScreenVM extends ChangeNotifier {
  int selectedScreen = 0;
  changeScreen(int index) {
    selectedScreen = index;
    notifyListeners();
  }
}
