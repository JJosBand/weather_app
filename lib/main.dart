import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/firebase.dart';
import 'package:weather_app/widgets/element_bar_indicator.dart';
// import 'package:weather_app/post_button.dart';  deprecated because of introduction of refresh indicator
import 'package:weather_app/fashion_view.dart';
import 'package:weather_app/models/weather_elements.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather & Fashion',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => WeatherElements(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: false,
          child: MainPage(),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Color(0xFF66CAE5),
      backgroundColor: Colors.black,
      onRefresh: () {
        return getWeatherInfo(context);
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: FashionPageView()),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    WindChillIndicator(),
                    PrecipitationIndicator(),
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          FineDustIndicator(),
                          UltraFineDustIndicator(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
