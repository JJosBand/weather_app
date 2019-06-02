import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class ElementBarIndicator extends StatelessWidget {
  
  const ElementBarIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '체감온도',
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'Arita'),
                ),
                FAProgressBar(
                  currentValue: 50,
                  maxValue: 60,
                  // backgroundColor: ,
                ),
                Text('')
              ],
            ),
          )),
    );
  }
}
