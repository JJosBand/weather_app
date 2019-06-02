import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather_elements.dart';

class ElementBarIndicator extends StatelessWidget {
  final String elementName;
  final String elementUnit;
  final num elementValue;
  final int elementMaxValue;
  final double size;

  const ElementBarIndicator(
    this.elementName,
    this.elementUnit,
    this.elementValue,
    this.elementMaxValue, {
    this.size = 15,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    elementName,
                    style: TextStyle(fontSize: 20, fontFamily: 'Arita'),
                  ),
                ),
                FAProgressBar(
                  displayText: elementUnit,
                  currentValue: elementValue,
                  maxValue: elementMaxValue,
                  size: size,
                ),
              ],
            ),
          )),
    );
  }
}

class WindChillIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherElements>(
      builder: (context, elements, _) => ElementBarIndicator(
            "체감온도",
            '°C',
            elements.windChill.round(),
            40,
            size: 30,
          ),
    );
  }
}

class PrecipitationIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherElements>(
      builder: (context, elements, _) => ElementBarIndicator(
            "강수량",
            'mm',
            elements.precipitation,
            200,
          ),
    );
  }
}

class FineDustIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherElements>(
      builder: (context, elements, _) => ElementBarIndicator(
            "미세먼지",
            '㎍/m³',
            elements.fdust,
            200,
          ),
    );
  }
}

class UltraFineDustIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherElements>(
      builder: (context, elements, _) => ElementBarIndicator(
            "초미세먼지",
            '㎍/m³',
            elements.ffdust,
            200,
          ),
    );
  }
}
