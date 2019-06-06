import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:daily_fit/location.dart';
import 'package:daily_fit/models/weather_elements.dart';
import 'package:html/parser.dart';

class WeatherDataOpertation {
  static const String _urlFirebase =
      'https://weather-server-57a80.firebaseio.com/weathers.json';

  String _aerisClientId = 'KscPtRtJwdVZjGLLfVEhk';
  String _aerisClientSecret = 'BTtFxVyqTme7AgmIcLHnGARbaMrtcd9CIqR7qwtx';
  String _kakaoAuth = "KakaoAK 6a7d9991f3b4ee36fe7b8dc2be7405c2";
  Map<String, dynamic> _weatherInfo;
  Map<String, double> coordinate;

  // Deprecated..
  // Future<void> getWeatherInfo(BuildContext context) async {
  //   final weatherInfoProvider = Provider.of<WeatherElements>(context);
  //   coordinate = await getCurrentLocation();
  //   final lat = coordinate['lat'];
  //   final lng = coordinate['lng'];

  //   final urlCurrentWeather =
  //       'https://api.aerisapi.com/observations/closest?p=$lat,$lng&client_id=$_aerisClientId&client_secret=$_aerisClientSecret';
  //   final urlForecast =
  //       'https://api.aerisapi.com/forecasts/$lat,$lng?client_id=$_aerisClientId&client_secret=$_aerisClientSecret';
  //   final urlAirquality =
  //       'https://api.aerisapi.com/airquality/$lat,$lng?client_id=$_aerisClientId&client_secret=$_aerisClientSecret';

  //   try {
  //     final resCurrentWeather = await http.get(urlCurrentWeather);
  //     final resForecast = await http.get(urlForecast);
  //     final resAirquality = await http.get(urlAirquality);

  //     final Map<String, dynamic> currentWeatherInfoDetail =
  //         json.decode(resCurrentWeather.body);
  //     final Map<String, dynamic> forecastWeatherInfoDetail =
  //         json.decode(resForecast.body);
  //     final Map<String, dynamic> airInfoDetail =
  //         json.decode(resAirquality.body);

  //     final Map<String, dynamic> temps = {
  //       'current': currentWeatherInfoDetail['response'][0]['ob']['tempC'],
  //       'max': forecastWeatherInfoDetail['response'][0]['periods'][0]
  //           ['maxTempC'],
  //       'min': forecastWeatherInfoDetail['response'][0]['periods'][0]
  //           ['minTempC'],
  //       'avg': forecastWeatherInfoDetail['response'][0]['periods'][0]
  //           ['avgTempC'],
  //     };

  //     final Map<String, dynamic> winds = {
  //       'current': currentWeatherInfoDetail['response'][0]['ob']
  //           ['windSpeedKPH'],
  //       'max': forecastWeatherInfoDetail['response'][0]['periods'][0]
  //           ['windSpeedMaxKPH'],
  //       'min': forecastWeatherInfoDetail['response'][0]['periods'][0]
  //           ['windSpeedMinKPH'],
  //       'avg': forecastWeatherInfoDetail['response'][0]['periods'][0]
  //           ['windSpeedKPH'],
  //     };

  //     final Map<String, dynamic> windChills = {
  //       'current': _getWindChill(temps['current'], winds['current']),
  //       'avg': _getWindChill(temps['avg'], winds['avg']),
  //     };

  //     _weatherInfo = {
  //       'temps': temps,
  //       'winds': winds,
  //       'rain': forecastWeatherInfoDetail['response'][0]['periods'][0]
  //           ['precipMM'] ??= 0,
  //       'ffdust': airInfoDetail['response'][0]['periods'][0]['pollutants'][1]
  //           ['valueUGM3'],
  //       'fdust': airInfoDetail['response'][0]['periods'][0]['pollutants'][2]
  //           ['valueUGM3'],
  //       'windChills': windChills
  //     };

  //     // Update local app data
  //     weatherInfoProvider.windChill = _weatherInfo['windChills']['current'];
  //     weatherInfoProvider.precipitation = _weatherInfo['rain'];
  //     weatherInfoProvider.fdust = _weatherInfo['fdust'];
  //     weatherInfoProvider.ffdust = _weatherInfo['ffdust'];
  //     print('Aeris에서 성공적으로 데이터를 가져왔습니다.');
  //     await _putWeatherInfo();
  //   } catch (e) {
  //     print('Aeris에서 데이터를 가져오는데 실패했습니다.');
  //     await getWeatherInfoFromFirebase(context);
  //   }
  // }

  Future<void> _putWeatherInfo() async {
    final resPost =
        await http.put(_urlFirebase, body: json.encode(_weatherInfo));
    if (resPost.statusCode == 200) {
      print('Firebase가 성공적으로 업데이트 되었습니다.');
    }
  }

  // Deprecated
  // Future<void> getWeatherInfoFromFirebase(BuildContext context) async {
  //   final weatherInfoProvider = Provider.of<WeatherElements>(context);

  //   final resGet = await http.get(_urlFirebase);
  //   _weatherInfo = json.decode(resGet.body);

  //   // Update local app data
  //   weatherInfoProvider.windChill = _weatherInfo['windChills']['current'];
  //   weatherInfoProvider.precipitation = _weatherInfo['rain'];
  //   weatherInfoProvider.fdust = _weatherInfo['fdust'];
  //   weatherInfoProvider.ffdust = _weatherInfo['ffdust'];

  //   if (resGet.statusCode == 200) {
  //     print('Firebase로부터 성공적으로 데이터를 가져왔습니다.');
  //   }
  // }
  
  // Deprecated
  // num _getWindChill(num temp, num wind) {
  //   return (13.12 +
  //       0.6215 * temp -
  //       11.37 * pow(wind, 0.16) +
  //       0.3965 * temp * pow(wind, 0.16));
  // }

  Future<void> getWeatherInfoFromNaver(BuildContext context) async {
    final weatherInfoProvider = Provider.of<WeatherElements>(context);

    var addressName = await _getAdminAreaInfo();
    var searchKeyword = addressName.split(' ').join('+') + '+강수량';

    String url =
        "https://search.naver.com/search.naver?sm=tab_hty.top&where=nexearch&query=$searchKeyword";
    var responseNaver = await http.get(url);

    // Reason for compute() function..
    // Because 'parse()' mehtod is hard computing function,
    // spawns new isolate to prevent UI from halting.
    var document = await compute(parse, responseNaver.body);

    var mainInfo = document.getElementsByClassName('main_info')[0];
    var currentTempStr = mainInfo
        .getElementsByClassName('info_temperature')[0]
        .getElementsByClassName('todaytemp')[0]
        .text;
    var currentWindChillStr = mainInfo
        .getElementsByClassName('sensible')[0]
        .getElementsByClassName('num')[0]
        .text;
    var maxTempStr = mainInfo.getElementsByClassName('max')[0].text;
    var minTempStr = mainInfo.getElementsByClassName('min')[0].text;
    var rainInfo = document
        .getElementsByClassName('info_list rainfall _tabContent')[0]
        .getElementsByTagName('dl');

    num maxPrecipitation = 0;

    for (var dl in rainInfo) {
      // 다음 날짜에 대한 정보가 나오면 루프 중단
      if (dl.getElementsByClassName('tomorrow').length != 0)
        break;

      var valueArr = dl
          .getElementsByClassName('item_condition')[0]
          .getElementsByTagName('span')[0]
          .text
          .split('~');
      var precipitation = num.tryParse(valueArr.length == 2 ? valueArr[1] : valueArr[0]);
      if (precipitation != null) {
        if (maxPrecipitation < precipitation) {
          maxPrecipitation = precipitation;
        }
      }
    }

    var detailInfo = document.getElementsByClassName('detail_box')[0];
    var dustInfo = detailInfo.getElementsByTagName('dd');
    var fdustStr = dustInfo[0].getElementsByClassName('num')[0].text;
    var ffdustStr = dustInfo[1].getElementsByClassName('num')[0].text;

    // Preprocess Data
    num currentTemp = num.parse(currentTempStr);
    num currentWindChill = num.parse(currentWindChillStr);
    num maxTemp = num.parse(maxTempStr.replaceFirst('˚', ''));
    num minTemp = num.parse(minTempStr.replaceFirst('˚', ''));
    num fdust = num.parse(fdustStr.replaceFirst('㎍/㎥', ''));
    num ffdust = num.parse(ffdustStr.replaceFirst('㎍/㎥', ''));

    // print(addressName);
    // print('현재 온도 $currentTemp');
    // print('현재 체감온도 $currentWindChill');
    // print('최고 기온 $maxTemp');
    // print('최저 기온 $minTemp');
    // print('예상 총 강수량 $totalPrecipitation');
    // print('미세먼지 $fdust');
    // print('초미세먼지 $ffdust');

    var temps = {
      'current': currentTemp,
      'max': maxTemp,
      'min': minTemp,
    };

    _weatherInfo = {
      'fdust': fdust,
      'ffdust': ffdust,
      'temps': temps,
      'rain': maxPrecipitation,
      'windChill': currentWindChill,
    };
    print('Naver로부터 성공적으로 데이터를 가져왔습니다.');

    // Update local data
    weatherInfoProvider.windChill = currentWindChill;
    weatherInfoProvider.precipitation = maxPrecipitation;
    weatherInfoProvider.fdust = fdust;
    weatherInfoProvider.ffdust = ffdust;
    weatherInfoProvider.maxTemp = maxTemp;
    weatherInfoProvider.minTemp = minTemp;

    await _putWeatherInfo();
  }

  Future<String> _getAdminAreaInfo() async {
    coordinate = await getCurrentLocation();

    String url =
        "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=${coordinate['lng']}&y=${coordinate['lat']}";
    Map<String, String> headers = {
      'Authorization': _kakaoAuth,
    };
    var response = await http.get(url, headers: headers);
    var addressName =
        json.decode(response.body)['documents'][0]['address_name'];
    print(addressName);
    return addressName;
  }

  Future<void> putFakeWeatherInfo(BuildContext context,
      {num windChill,
      num precipitation,
      num fdust,
      num ffdust,
      Map<String, num> temps}) async {
    var weatherInfoProvider = Provider.of<WeatherElements>(context);
    weatherInfoProvider.windChill = windChill;
    weatherInfoProvider.precipitation = precipitation;
    weatherInfoProvider.fdust = fdust;
    weatherInfoProvider.ffdust = ffdust;
    weatherInfoProvider.maxTemp = temps['max'];
    weatherInfoProvider.minTemp = temps['min'];

    _weatherInfo = {
      'fdust': fdust,
      'ffdust': ffdust,
      'rain': precipitation,
      'temps': temps,
      'windChill': windChill,
    };

    await _putWeatherInfo();
  }
}
