import 'dart:convert';
import 'package:http/http.dart' as http;

class Mode {
  static String _url = 'https://weather-server-57a80.firebaseio.com/mode.json';

  static Future<int> changeMode({int mode}) async {
    var responseGet = await http.get(_url);
    int newMode = json.decode(responseGet.body)['mode'];

    newMode += 1;
    
    if (newMode > 2) {
      newMode = 1;
    }

    newMode = mode ?? newMode;

    Map<String, int> modeMap = {
      'mode': newMode,
    };
    var response = await http.put(_url, body: json.encode(modeMap));
    return response.statusCode;
  }
}