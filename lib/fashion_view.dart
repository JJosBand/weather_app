import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class FashionPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FashionAnimationState();
  }
}

class _FashionAnimationState extends State<FashionPageView> {
  final List<FlareActor> actors = [
    FlareActor("assets/umbrella.flr", fit: BoxFit.contain, animation: 'idle'),
    FlareActor("assets/Human_animation_1.flr",
        fit: BoxFit.contain, animation: 'Untitled'),
    FlareActor("assets/Human_animation_2.flr",
        fit: BoxFit.contain, animation: 'Untitled'),
    FlareActor("assets/Human_animation_3.flr",
        fit: BoxFit.contain, animation: 'Untitled'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF02DAF4),
              Colors.transparent,
            ],
          ),
        ),
        child: PageView(children: actors));
  }
}
