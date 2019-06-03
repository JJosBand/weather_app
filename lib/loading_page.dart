import 'package:flutter/material.dart';
import 'package:weather_app/firebase.dart';
import 'package:after_layout/after_layout.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with AfterLayoutMixin<LoadingPage> {
  bool _isLoading = false;

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan, Colors.amber],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.cloud_done,
                  size: MediaQuery.of(context).size.width / 3),
              _isLoading ? CircularProgressIndicator() : Icon(Icons.done)
            ],
          ),
        ),
      ),
    );
  }

  void afterFirstLayout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    FirebaseModel().getWeatherInfo(context).then((_) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/home');
    });
  }
}