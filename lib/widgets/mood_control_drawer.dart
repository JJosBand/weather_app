import 'package:flutter/material.dart';
import 'package:daily_fit/alarm.dart';
import 'package:daily_fit/mode_changer.dart';
import 'package:daily_fit/weather_data_utility.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class MoodControlDrawer extends StatelessWidget {
  MoodControlDrawer({
    Key key,
  }) : super(key: key);

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  // Changeable in demo
  final InputType inputType = InputType.both;
  final bool editable = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        Center(child: Text("무드등 조작", style: TextStyle(fontSize: 30))),
        ListTile(
          title: Text('무드등 모드 변경'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('모드 변경'),
                      content: Text('어떤 모드로 변경하시겠습니까?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('수면'),
                          onPressed: () {
                            changeMode(context, mode: 1);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('날씨'),
                          onPressed: () {
                            changeMode(context, mode: 2);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          },
        ),
        ListTile(
          title: Text('알람 설정'),
          onTap: () async {
            DateTime setTime;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('알람 설정'),
                    content: DateTimePickerFormField(
                      inputType: InputType.time,
                      format: DateFormat("HH:mm"),
                      editable: false,
                      decoration: InputDecoration(),
                      onChanged: (dt) {
                        setTime = dt;
                      },
                    ),
                    actions: <Widget>[
                      FlatButton(child: Text('설정'), onPressed: () {
                        Alarm.postAlarmTime(context, setTime);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },),
                      FlatButton(child: Text('취소'), onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      })
                    ],
                  ),
            );
          },
        ),
        ListTile(
          title: Text('Fake 데이터 보내기'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Fake 날씨 설정'),
                    content: Text('어떤 상황을 설정하시겠습니까?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('겨울, 미세먼지'),
                        onPressed: () async {
                          Map<String, num> temps = {
                            'current': 3,
                            'max': 6,
                            'min': -5,
                          };
                          await WeatherDataOpertation().putFakeWeatherInfo(
                              context,
                              fdust: 123,
                              ffdust: 87,
                              precipitation: 0,
                              temps: temps,
                              windChill: 2);
                          Future.delayed(Duration(milliseconds: 500)).then(
                              (_) => Navigator.pushReplacementNamed(
                                  context, '/home'));
                        },
                      ),
                      FlatButton(
                        child: Text('여름, 비'),
                        onPressed: () async {
                          Map<String, num> temps = {
                            'current': 20,
                            'max': 22,
                            'min': 18,
                          };
                          await WeatherDataOpertation().putFakeWeatherInfo(
                              context,
                              fdust: 26,
                              ffdust: 15,
                              precipitation: 7,
                              temps: temps,
                              windChill: 18);
                          Future.delayed(Duration(milliseconds: 500)).then(
                              (_) => Navigator.pushReplacementNamed(
                                  context, '/home'));
                        },
                      ),
                    ],
                  ),
            );
          },
        )
      ],
    ));
  }
}
