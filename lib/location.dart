import 'package:flutter/services.dart';
import 'package:location/location.dart';

Future<Map<String, double>> getCurrentLocation() async {
  LocationData currentLocation;
  Map<String, double> coordinate = {};

  var location = Location();
  try {
    currentLocation = await location.getLocation();
    coordinate['lat'] = currentLocation.latitude;
    coordinate['lng'] = currentLocation.longitude;
  } on PlatformException catch (e) {
    print('Platform Exception Occur..! : ${e.message}');
    coordinate = null;
  }
  print(coordinate['lat']);
  print(coordinate['lng']);
  return coordinate;
}
