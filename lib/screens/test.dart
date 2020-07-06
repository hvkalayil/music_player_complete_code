import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static String id = 'TestScreen';
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String theme = 'Light';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100,
        color: Colors.red,
        child: GestureDetector(
          onTap: () {
            setState(() {
              theme = 'Dark';
            });
          },
          child: FlareActor(
            'assets/theme_mode.flr',
            animation: theme,
            callback: (s) {
              print(s);
            },
          ),
        ),
      ),
    );
  }
}
