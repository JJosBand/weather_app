import 'package:flutter/widgets.dart';

class Mode with ChangeNotifier {
  int _mode;

  int get mode => _mode;
  set mode(int value) {
    if (value == 3) {
      return;
    }
    _mode = value;
    notifyListeners();
  }
}