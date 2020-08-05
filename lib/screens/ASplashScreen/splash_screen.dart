import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/screens/BHomeScreen/home_screen.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'SplashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double val = 0;

  ThemeNotifier themeNotifier;
  bool showReason = false;
  Future<void> initializePlayer() async {
    final bool status = await SavePreference.getBool('showSplash') ?? true;
    if (status) {
      if (await Permission.storage.request().isGranted) {
        AudioFunctions audioFunctions = AudioFunctions();
        await audioFunctions.getLocalSongs();
        themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
        themeNotifier.setAudioFunctions(audioFunctions);
        Navigator.popAndPushNamed(context, HomeScreen.id);
      } else if (await Permission.storage.isPermanentlyDenied) {
        SavePreference.saveBool('showSplash', false);
        Navigator.pushNamed(context, HomeScreen.id);
      } else {
        setState(() {
          showReason = true;
        });
      }
    } else {
      Navigator.popAndPushNamed(context, HomeScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    print(showReason);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
          child: showReason
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'assets/permission.png',
                      scale: 3,
                    ),
                    Text(
                      'Unable to access files. Grant permission to '
                      'load your songs. Or continue to the app',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Theme.of(context).primaryColorLight,
                            boxShadow: kRaisedButtonShadow.boxShadow,
                          ),
                          child: FlatButton(
                            onPressed: () => Navigator.popAndPushNamed(
                                context, HomeScreen.id),
                            child: Text(
                              'Continue without \n permissions',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Theme.of(context).primaryColorLight,
                            boxShadow: kRaisedButtonShadow.boxShadow,
                          ),
                          child: FlatButton(
                            onPressed: () async {
                              if (await Permission
                                  .storage.isPermanentlyDenied) {
                                openAppSettings();
                              } else {
                                initializePlayer();
                              }
                            },
                            child: Text('Grant Permission'),
                          ),
                        ),
                      ],
                    )
                  ],
                )

              //GRANTED
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 500,
                      child: Theme.of(context).primaryColorLight ==
                              Color(0xffe3ecef)
                          ? FlareActor(
                              'assets/loading_music_light.flr',
                              animation: 'searching',
                            )
                          : FlareActor(
                              'assets/loading_music_dark.flr',
                              animation: 'searching',
                            ),
                    ),
                    Text('Loading your songs')
                  ],
                )),
    );
  }
}
