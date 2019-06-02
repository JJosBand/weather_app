import 'package:flutter/foundation.dart';

class WeatherElements with ChangeNotifier {
  double _windChill= 0;
  int _precipitation = 0;
  int _fdust = 0;
  int _ffdust = 0;

  double get windChill => _windChill;
  set windChill(double newValue) {
    _windChill = newValue;
    notifyListeners();
  }

  int get precipitation => _precipitation;
  set precipitation(int newValue) {
    _precipitation = newValue;
    notifyListeners();
  }

  int get fdust => _fdust;
  set fdust(int newValue) {
    _fdust = newValue;
    notifyListeners();
  }
  int get ffdust => _ffdust;
  set ffdust(int newValue) {
    _ffdust = newValue;
    notifyListeners();
  }
}