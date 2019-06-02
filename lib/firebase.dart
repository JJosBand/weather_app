import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:weather_app/location.dart';

const CLIENT_ID = 'KscPtRtJwdVZjGLLfVEhk';
const CLIENT_SECRET = 'BTtFxVyqTme7AgmIcLHnGARbaMrtcd9CIqR7qwtx';

Future<void> getWeatherInfo() async {
  final coordinate = await getCurrentLocation();
  final lat = coordinate['lat'];
  final lng = coordinate['lng'];

  print('start');

  final urlCurrentWeather =
      'https://api.aerisapi.com/observations/closest?p=$lat,$lng&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET';
  final urlForecast = 'https://api.aerisapi.com/forecasts/$lat,$lng?client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET';
  final urlAirquality = 'https://api.aerisapi.com/airquality/$lat,$lng?client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET';
  final urlFirebase = 'https://weather-server-57a80.firebaseio.com/weathers.json';

  final resCurrentWeather = await http.get(urlCurrentWeather);
  final resForecast = await http.get(urlForecast);
  final resAirquality = await http.get(urlAirquality);
  
  final Map<String, dynamic> currentWeatherInfoDetail = json.decode(resCurrentWeather.body);
  final Map<String, dynamic> forecastWeatherInfoDetail = json.decode(resForecast.body);
  final Map<String, dynamic> airInfoDetail = json.decode(resAirquality.body);

  final Map<String, dynamic> temps = {
    'current': currentWeatherInfoDetail['response'][0]['ob']['tempC'],
    'max': forecastWeatherInfoDetail['response'][0]['periods'][0]['maxTempC'],
    'min': forecastWeatherInfoDetail['response'][0]['periods'][0]['minTempC'],
    'avg': forecastWeatherInfoDetail['response'][0]['periods'][0]['avgTempC'],
  };

  final Map<String, dynamic> winds = {
    'current': currentWeatherInfoDetail['response'][0]['ob']['windSpeedKPH'],
    'max': forecastWeatherInfoDetail['response'][0]['periods'][0]['windSpeedMaxKPH'],
    'min': forecastWeatherInfoDetail['response'][0]['periods'][0]['windSpeedMinKPH'],
    'avg': forecastWeatherInfoDetail['response'][0]['periods'][0]['windSpeedKPH'],
  };

  final Map<String, dynamic> windChills = {
    'current': getWindChill(temps['current'], winds['current']),
    'avg': getWindChill(temps['avg'], winds['avg']),
  };

  final Map<String, dynamic> weatherInfo = {
    'temps': temps,
    'winds': winds,
    'rain': forecastWeatherInfoDetail['response'][0]['periods'][0]['precipMM'] ??= 0,
    'ffdust': airInfoDetail['response'][0]['periods'][0]['pollutants'][1]['valueUGM3'],
    'fdust': airInfoDetail['response'][0]['periods'][0]['pollutants'][2]['valueUGM3'],
    'windChills': windChills
  };

  // Update firebase server data
  final resPost = await http.put(urlFirebase, body: json.encode(weatherInfo));
  print(resPost.statusCode);
}

num getWindChill(num temp, num wind) {
  return (13.12 + 0.6215*temp - 11.37*pow(wind, 0.16) + 0.3965*temp*pow(wind, 0.16));
}