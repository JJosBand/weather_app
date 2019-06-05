import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/mode.dart';

class Alarm {
  static String _url = 'https://weather-server-57a80.firebaseio.com/alarm.json';

  static Future<int> postAlarmDataFromNowOneMin() async {
    var now = DateTime.now();
    Map<String, int> alarmTime = {
      'time': now.hour*60 + now.minute + 1
    };
    Mode.changeMode(mode: 3);
    var response = await http.put(_url, body: json.encode(alarmTime));

    return response.statusCode;
  }
}