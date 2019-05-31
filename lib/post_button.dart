import 'package:flutter/material.dart';
import 'package:weather_app/firebase.dart';

class PostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        getWeatherInfo();
        print('button clicked');
      },
      tooltip: 'Http Post',
      child: Icon(Icons.cloud_upload),
    );
  }
}
