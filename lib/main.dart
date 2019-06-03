import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/loading_page.dart';
import 'package:weather_app/firebase.dart';
import 'package:weather_app/widgets/element_bar_indicator.dart';
import 'package:weather_app/fashion_view.dart';
import 'package:weather_app/models/weather_elements.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => WeatherElements(),
          child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weather & Fashion',
          routes: {
            '/': (context) => LoadingPage(),
            '/home': (context) => HomePage(),
          }),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Color(0xFF66CAE5),
      backgroundColor: Colors.black,
      onRefresh: () {
        return FirebaseModel().getWeatherInfo(context);
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
                    Flexible(
                      flex: 3,
                      child: WindChillIndicator(),
                    ),
                    Flexible(
                      flex: 3,
                      child: PrecipitationIndicator(),
                    ),
                    Flexible(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: FineDustIndicator(),
                          ),
                          Flexible(
                            flex: 1,
                            child: UltraFineDustIndicator(),
                          ),
                        ],
                      ),
                    ),
                    Spacer(flex: 2)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
