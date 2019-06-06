import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_fit/models/mode.dart';
import 'package:http/http.dart' as http;

Future<int> changeMode(BuildContext context, {int mode}) async {
  String url = 'https://weather-server-57a80.firebaseio.com/mode.json';
  var modeProvider = Provider.of<Mode>(context);

  var responseGet = await http.get(url);
  int newMode = json.decode(responseGet.body)['mode'];

  newMode += 1;

  if (newMode > 2) {
    newMode = 1;
  }

  newMode = mode ?? newMode;
  Map<String, int> modeMap = {
    'mode': newMode,
  };

  modeProvider.mode = newMode;
  
  var response = await http.put(url, body: json.encode(modeMap));
  return response.statusCode;
}
