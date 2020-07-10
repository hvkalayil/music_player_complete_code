import 'package:flutter/material.dart';
import 'package:musicplayer/utilities/spotify_client.dart';

class TestScreen extends StatefulWidget {
  static String id = 'TestScreen';
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
    yay();
  }

  Future<void> yay() async {
    final data = await SpotifyAPI.getData('Pookal Pookum', 5);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColorDark
              ])),
        ),
      ),
    );
  }
}
