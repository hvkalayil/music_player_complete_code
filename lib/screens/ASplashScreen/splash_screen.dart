import 'package:flutter/material.dart';
import 'package:musicplayer/screens/BHomeScreen/home_screen.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'SplashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double val = 0;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void initializePlayer() async {
    AudioFunctions audioFunctions = AudioFunctions();
    await audioFunctions.getLocalSongs();
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.setAudioFunctions(audioFunctions);
    Navigator.popAndPushNamed(context, HomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            alignment: Alignment.center, child: CircularProgressIndicator()),
      ),
    );
  }
}
