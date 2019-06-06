import 'package:flutter/material.dart';
import 'package:daily_fit/weather_data_utility.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flare_flutter/flare_actor.dart';

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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.cyanAccent, Colors.purple],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Daily Fit',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 5,
                    fontFamily: 'Aerolite'),
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: FlareActor('assets/logo.flr',
                      fit: BoxFit.contain, animation: 'idle')),
              SizedBox(height: MediaQuery.of(context).size.height/10),
              _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                    )
                  : Icon(Icons.done, size: 40,)
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
    var operation = WeatherDataOpertation();
    operation.getWeatherInfoFromNaver(context).then((_) {
      setState(() {
        _isLoading = false;
      });
      Future.delayed(Duration(seconds: 1, milliseconds: 500)).then((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    });
  }
}
