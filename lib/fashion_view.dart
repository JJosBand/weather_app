import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:weather_app/models/weather_elements.dart';
import 'package:provider/provider.dart';

class FashionPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FashionAnimationState();
  }
}

class _FashionAnimationState extends State<FashionPageView> {
  final List<FlareActor> actors = [
    FlareActor("assets/umbrella.flr", fit: BoxFit.contain, animation: 'idle'),
    FlareActor("assets/mask.flr", fit: BoxFit.contain, animation: 'Untitled'),
    FlareActor("assets/Human_animation_1.flr",
        fit: BoxFit.contain, animation: 'Untitled'),
    FlareActor("assets/Human_animation_2.flr",
        fit: BoxFit.contain, animation: 'Untitled'),
    FlareActor("assets/Human_animation_3.flr",
        fit: BoxFit.contain, animation: 'Untitled'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherElements>(
      builder: (context, weatherElements, _) {
        var value = weatherElements.fdust;
        Color color;
        
        if (value <= 15) {
        color = Colors.blue[900];
      } else if (value <= 30) {
        color = Colors.blue[300];
      } else if (value <= 40) {
        color = Colors.cyan[400];
      } else if (value <= 50) {
        color = Colors.green;
      } else if (value <= 75) {
        color = Colors.orange;
      } else if (value <= 100) {
        color = Colors.red;
      } else if (value <= 150) {
        color = Colors.red[900];
      } else {
        color = Colors.black;
      }

        return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  color,
                  Colors.white,
                ],
              ),
            ),
            child: PageView(children: actors));
      },
    );
  }
}
