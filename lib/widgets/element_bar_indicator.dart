import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:daily_fit/models/weather_elements.dart';

class ElementBarIndicator extends StatelessWidget {
  final String elementName;
  final String elementUnit;
  final num elementValue;
  final int elementMaxValue;
  final Color progressColor;
  final double size;

  const ElementBarIndicator(
    this.elementName,
    this.elementUnit,
    this.elementValue,
    this.elementMaxValue,
    this.progressColor, {
    this.size = 15,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(2),
                child: Text(
                  elementName,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 40,
                      fontFamily: 'Nanumsquare'),
                ),
              ),
              FAProgressBar(
                displayText: elementUnit,
                currentValue: elementValue,
                maxValue: elementMaxValue,
                size: size,
                progressColor: progressColor,
                backgroundColor: Colors.grey[350],
                // changeColorValue: 10,
              ),
            ],
          ),
        ));
  }
}

class WindChillIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherElements>(builder: (context, elements, _) {
      var value = elements.windChill.round();
      Color progressColor;

      if (value < 5) {
        progressColor = Colors.indigoAccent;
      } else if (value < 17) {
        progressColor = Colors.lightBlue;
      } else if (value < 20) {
        progressColor = Colors.green[600];
      } else if (value < 25) {
        progressColor = Colors.amber;
      } else if (value < 30) {
        progressColor = Colors.amber[800];
      } else if (value < 33) {
        progressColor = Colors.orange[900];
      } else if (value < 37) {
        progressColor = Colors.deepOrange;
      } else {
        progressColor = Colors.red[700];
      }
      // 37.294
      return Row(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: ElementBarIndicator(
              "현재 체감온도",
              '°C',
              value,
              40,
              progressColor,
              size: MediaQuery.of(context).size.height / 30,
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(flex: 1),
                  Flexible(
                      flex: 2,
                      child: Text(
                        "최고 ${elements.maxTemp}℃",
                        style: TextStyle(color: Colors.red, fontFamily: 'Nanumsquare'),
                      )),
                  Spacer(flex:1),
                  Flexible(
                      flex: 2,
                      child: Text("최저 ${elements.minTemp}℃",
                          style: TextStyle(color: Colors.blue, fontFamily: 'Nanumsquare')))
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}

class PrecipitationIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherElements>(builder: (context, elements, _) {
      var value = elements.precipitation.round();
      Color progressColor;

      if (value <= 1) {
        progressColor = Colors.lightBlue[300];
      } else if (value <= 5) {
        progressColor = Colors.lightBlue[500];
      } else if (value <= 20) {
        progressColor = Colors.lightBlue[700];
      } else {
        progressColor = Colors.lightBlue[900];
      }

      return ElementBarIndicator(
        "예상 최대 강수량",
        'mm',
        value,
        50,
        progressColor,
        size: MediaQuery.of(context).size.height / 30,
      );
    });
  }
}

class FineDustIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherElements>(builder: (context, elements, _) {
      var value = elements.fdust.round();
      Color progressColor;

      if (value <= 15) {
        progressColor = Colors.blue[900];
      } else if (value <= 30) {
        progressColor = Colors.blue[300];
      } else if (value <= 40) {
        progressColor = Colors.cyan[400];
      } else if (value <= 50) {
        progressColor = Colors.green;
      } else if (value <= 75) {
        progressColor = Colors.orange;
      } else if (value <= 100) {
        progressColor = Colors.red;
      } else if (value <= 150) {
        progressColor = Colors.red[900];
      } else {
        progressColor = Colors.black;
      }

      return ElementBarIndicator(
        "미세먼지",
        '㎍/m³',
        value,
        155,
        progressColor,
        size: MediaQuery.of(context).size.height / 30,
      );
    });
  }
}

class UltraFineDustIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherElements>(builder: (context, elements, _) {
      var value = elements.ffdust.round();
      Color progressColor;

      if (value <= 8) {
        progressColor = Colors.blue[900];
      } else if (value <= 15) {
        progressColor = Colors.blue[300];
      } else if (value <= 20) {
        progressColor = Colors.cyan[400];
      } else if (value <= 25) {
        progressColor = Colors.green;
      } else if (value <= 37) {
        progressColor = Colors.orange;
      } else if (value <= 50) {
        progressColor = Colors.red;
      } else if (value <= 75) {
        progressColor = Colors.red[900];
      } else {
        progressColor = Colors.black;
      }

      return ElementBarIndicator(
        "초미세먼지",
        '㎍/m³',
        value,
        80,
        progressColor,
        size: MediaQuery.of(context).size.height / 30,
      );
    });
  }
}
