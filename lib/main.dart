import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/loading_page.dart';
import 'package:weather_app/weather_data_utility.dart';
import 'package:weather_app/widgets/element_bar_indicator.dart';
import 'package:weather_app/fashion_view.dart';
import 'package:weather_app/models/weather_elements.dart';
import 'package:weather_app/alarm.dart';
import 'package:weather_app/mode.dart';

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () async {
            var status = await Mode.changeMode();
            if (status == 200) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('성공'),
                        content: Text('무드등의 모드를 변경했습니다!'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                );
              }
          }),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Fake 데이터 보내기',
              style: TextStyle(fontSize: 25),
            ),
            decoration: BoxDecoration(color: Colors.cyan),
          ),
          ListTile(
            title: Text('겨울, 미세먼지'),
            onTap: () async {
              Map<String, num> temps = {
                'current': 3,
                'max': 6,
                'min': -5,
              };
              await WeatherDataOpertation().putFakeWeatherInfo(context,
                  fdust: 123,
                  ffdust: 87,
                  precipitation: 0,
                  temps: temps,
                  windChill: 2);
              Future.delayed(Duration(milliseconds: 500)).then(
                  (_) => Navigator.pushReplacementNamed(context, '/home'));
            },
          ),
          ListTile(
            title: Text('여름, 비'),
            onTap: () async {
              Map<String, num> temps = {
                'current': 20,
                'max': 22,
                'min': 18,
              };
              await WeatherDataOpertation().putFakeWeatherInfo(context,
                  fdust: 26,
                  ffdust: 15,
                  precipitation: 7,
                  temps: temps,
                  windChill: 18);
              Future.delayed(Duration(milliseconds: 500)).then(
                  (_) => Navigator.pushReplacementNamed(context, '/home'));
            },
          ),
          ListTile(
            title: Text('알람 설정'),
            onTap: () async {
              var status = await Alarm.postAlarmDataFromNowOneMin();
              if (status == 200) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('성공'),
                        content: Text('알람을 설정했습니다1'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                          )
                        ],
                      ),
                );
              }
            },
          )
        ],
      )),
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
        return WeatherDataOpertation().getWeatherInfoFromNaver(context);
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
                    Spacer(flex: 3)
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
