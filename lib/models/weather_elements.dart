import 'package:flutter/foundation.dart';

class WeatherElements with ChangeNotifier {
  num _windChill;
  num _precipitation;
  num _fdust;
  num _ffdust;
  num _maxTemp;
  num _minTemp;

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
  num get maxTemp => _maxTemp;
  set maxTemp(num newValue) {
    _maxTemp = newValue;
    notifyListeners();
  }
  num get minTemp => _minTemp;
  set minTemp(num newValue) {
    _minTemp = newValue;
    notifyListeners();
  }
}