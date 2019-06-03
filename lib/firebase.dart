import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_app/location.dart';
import 'package:weather_app/models/weather_elements.dart';

class FirebaseModel {
  static const String _urlFirebase =
        'https://weather-server-57a80.firebaseio.com/weathers.json';

  String _clientId = 'KscPtRtJwdVZjGLLfVEhk';
  String _clientSecret = 'BTtFxVyqTme7AgmIcLHnGARbaMrtcd9CIqR7qwtx';
  Map<String, dynamic> _weatherInfo;

  Future<void> getWeatherInfo(BuildContext context) async {
    final weatherInfoProvider = Provider.of<WeatherElements>(context);
    final coordinate = await getCurrentLocation();
    final lat = coordinate['lat'];
    final lng = coordinate['lng'];

    final urlCurrentWeather =
        'https://api.aerisapi.com/observations/closest?p=$lat,$lng&client_id=$_clientId&client_secret=$_clientSecret';
    final urlForecast =
        'https://api.aerisapi.com/forecasts/$lat,$lng?client_id=$_clientId&client_secret=$_clientSecret';
    final urlAirquality =
        'https://api.aerisapi.com/airquality/$lat,$lng?client_id=$_clientId&client_secret=$_clientSecret';

    try {
      final resCurrentWeather = await http.get(urlCurrentWeather);
      final resForecast = await http.get(urlForecast);
      final resAirquality = await http.get(urlAirquality);

    final Map<String, dynamic> currentWeatherInfoDetail =
        json.decode(resCurrentWeather.body);
    final Map<String, dynamic> forecastWeatherInfoDetail =
        json.decode(resForecast.body);
    final Map<String, dynamic> airInfoDetail = json.decode(resAirquality.body);

    final Map<String, dynamic> temps = {
      'current': currentWeatherInfoDetail['response'][0]['ob']['tempC'],
      'max': forecastWeatherInfoDetail['response'][0]['periods'][0]['maxTempC'],
      'min': forecastWeatherInfoDetail['response'][0]['periods'][0]['minTempC'],
      'avg': forecastWeatherInfoDetail['response'][0]['periods'][0]['avgTempC'],
    };

    final Map<String, dynamic> winds = {
      'current': currentWeatherInfoDetail['response'][0]['ob']['windSpeedKPH'],
      'max': forecastWeatherInfoDetail['response'][0]['periods'][0]
          ['windSpeedMaxKPH'],
      'min': forecastWeatherInfoDetail['response'][0]['periods'][0]
          ['windSpeedMinKPH'],
      'avg': forecastWeatherInfoDetail['response'][0]['periods'][0]
          ['windSpeedKPH'],
    };

    final Map<String, dynamic> windChills = {
      'current': _getWindChill(temps['current'], winds['current']),
      'avg': _getWindChill(temps['avg'], winds['avg']),
    };

    _weatherInfo = {
      'temps': temps,
      'winds': winds,
      'rain': forecastWeatherInfoDetail['response'][0]['periods'][0]
          ['precipMM'] ??= 0,
      'ffdust': airInfoDetail['response'][0]['periods'][0]['pollutants'][1]
          ['valueUGM3'],
      'fdust': airInfoDetail['response'][0]['periods'][0]['pollutants'][2]
          ['valueUGM3'],
      'windChills': windChills
    };

    // Update local app data
    weatherInfoProvider.windChill = _weatherInfo['windChills']['current'];
    weatherInfoProvider.precipitation = _weatherInfo['rain'];
    weatherInfoProvider.fdust = _weatherInfo['fdust'];
    weatherInfoProvider.ffdust = _weatherInfo['ffdust'];

    await this._putWeatherInfo();

    } catch(e) {
      print('Aeris에서 데이터를 가져오는데 실패했습니다.');
      _getWeatherInfoFromFirebase(context);
    }
  }

  Future<void> _putWeatherInfo() async {
    final resPost =
        await http.put(_urlFirebase, body: json.encode(_weatherInfo));
    if (resPost.statusCode == 200) {
      print('Firebase가 성공적으로 업데이트 되었습니다.');
    }
  }

  Future<void> _getWeatherInfoFromFirebase(BuildContext context) async {
    final weatherInfoProvider = Provider.of<WeatherElements>(context);

    final resGet = await http.get(_urlFirebase);
    _weatherInfo = json.decode(resGet.body);

    // Update local app data
    weatherInfoProvider.windChill = _weatherInfo['windChills']['current'];
    weatherInfoProvider.precipitation = _weatherInfo['rain'];
    weatherInfoProvider.fdust = _weatherInfo['fdust'];
    weatherInfoProvider.ffdust = _weatherInfo['ffdust'];

    if (resGet.statusCode == 200) {
      print('Firebase로부터 성공적으로 데이터를 가져왔습니다.');
    }
  }

  num _getWindChill(num temp, num wind) {
    return (13.12 +
        0.6215 * temp -
        11.37 * pow(wind, 0.16) +
        0.3965 * temp * pow(wind, 0.16));
  }
}
