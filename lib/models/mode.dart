import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Mode with ChangeNotifier {
  static String _url = 'https://weather-server-57a80.firebaseio.com/mode.json';
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