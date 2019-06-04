import 'package:flutter/foundation.dart';

class WeatherElements with ChangeNotifier {
  num _windChill= 0;
  num _precipitation = 0;
  num _fdust = 0;
  num _ffdust = 0;

  num get windChill => _windChill;
  set windChill(num newValue) {
    _windChill = newValue;
    notifyListeners();
  }

  num get precipitation => _precipitation;
  set precipitation(num newValue) {
    _precipitation = newValue;
    notifyListeners();
  }

  num get fdust => _fdust;
  set fdust(num newValue) {
    _fdust = newValue;
    notifyListeners();
  }
  num get ffdust => _ffdust;
  set ffdust(num newValue) {
    _ffdust = newValue;
    notifyListeners();
  }
}