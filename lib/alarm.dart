import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:daily_fit/mode_changer.dart';

class Alarm {
  static String _url = 'https://weather-server-57a80.firebaseio.com/alarm.json';

  static Future<int> postAlarmDataFromNowOneMin(BuildContext context) async {
    var now = DateTime.now();
    Map<String, dynamic> alarmData = {
      'time': now.hour*60 + now.minute + 1,
      'isAlarmed': false
    };
    changeMode(context, mode: 3);
    var response = await http.put(_url, body: json.encode(alarmData));

    return response.statusCode;
  }

  static Future<int> postAlarmTime(BuildContext context, DateTime time) async {
    int setTime = time.hour*60 + time.minute;
    Map<String, dynamic> alarmData = {
      'time': setTime,
      'isAlarmed': false
    };
    changeMode(context, mode: 3);
    var response = await http.put(_url, body: json.encode(alarmData));

    return response.statusCode;
  }
}