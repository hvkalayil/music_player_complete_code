import 'package:equalizer/equalizer.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/BHomeScreen/home_screen.dart';
import 'package:musicplayer/theme/theme.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';
import 'package:provider/provider.dart';

class DrawerComponent extends StatefulWidget {
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  String theme;
  bool isDark, pause = false;
  @override
  void initState() {
    super.initState();
    final _themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    isDark = _themeNotifier.getTheme() == darkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(10),
        color: Theme.of(context).secondaryHeaderColor,
        child: ListView(
          children: [
            Text('OPTIONS',
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center),
            SizedBox(height: 10),
            Column(
              children: [
                //OPTIONS
                Column(
                  children: kMenuItems.entries
                      .map((e) => makeMenuItems(e.key, e.value, context))
                      .toList(),
                ),

                //DARK MODE
                Container(
                  height: 100,
                  width: 100,
                  child: GestureDetector(
                    onTap: () {
                      if (pause) {
                        setState(() {
                          pause = !pause;
                          isDark = !isDark;
                        });
                        final _themeNotifier =
                            Provider.of<ThemeNotifier>(context, listen: false);
                        isDark
                            ? _themeNotifier.setTheme(darkTheme)
                            : _themeNotifier.setTheme(lightTheme);
                        SavePreference.saveBool('darkMode', isDark);
                      }
                    },
                    child: FlareActor(
                      'assets/theme_mode.flr',
                      animation: isDark ? 'Dark' : 'Light',
                      isPaused: pause,
                      callback: (s) {
                        setState(() {
                          pause = !pause;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container makeMenuItems(IconData ico, String name, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: FlatButton(
        shape: RoundedRectangleBorder(),
        onPressed: () async {
          //EQ
          if (name == 'EQUALIZER') {
            Equalizer.init(0);
            Equalizer.open(0);
          }

          //TOUR
          else if (name == 'TAKE A TOUR') {
            SavePreference.saveBool('showTour', true);
            final _themeNotifier =
                Provider.of<ThemeNotifier>(context, listen: false);
            _themeNotifier.setHideList(true);
            Navigator.popUntil(
                context, (route) => route.settings.name == HomeScreen.id);
            FeatureDiscovery.clearPreferences(context, featureIds);
            FeatureDiscovery.discoverFeatures(context, featureIds);
          }

          //ABOUT
          else if (name == 'ABOUT') {
            showAboutDialog(
                context: context,
                applicationName: 'PLAYA',
                applicationVersion: 'Version 1',
                children: [
                  Text('This is a simple music player '
                      'designed in a neumorphistic design.'
                      ' This is an early release version.'
                      ' Feel free to report any bugs')
                ]);
          }

//          //RATE
//          else if (name == 'RATE APP') {
//          }

          //DEFAULT DOWNLOAD PATH
          else if (name == 'DEFAULT PATH') {
            //Getting path
            final String path = await FilePicker.getDirectoryPath() ?? '';
            if (path != '') {
              final themeNotifier =
                  Provider.of<ThemeNotifier>(context, listen: false);
              themeNotifier.setDefaultPath(path);
            }
          }

          //TIMER
          else if (name == 'SET TIMER') {}
        },
        child: name == 'SET TIMER'
            ? ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(ico, color: Colors.white),
                    SizedBox(width: 10),
                    Text(name, style: Theme.of(context).textTheme.headline4),
                  ],
                ),
                children: [
                  GestureDetector(
                    onTap: () => setTimer(true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Turn off after playing current song',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 16)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setTimer(false),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Turn off after playing current playlist',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 16)),
                    ),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(ico, color: Colors.white),
                      SizedBox(width: 10),
                      Text(name, style: Theme.of(context).textTheme.headline4),
                    ],
                  ),
                  Icon(FontAwesomeIcons.angleRight, color: Colors.white)
                ],
              ),
      ),
    );
  }

  void setTimer(bool isSong) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    if (!isSong) {
      if (!themeNotifier.playTheList) {
        FlutterToast.showToast(msg: 'No Playlist is playing now');
        return;
      }
    }

    final String type = isSong ? 'this song' : 'this playlist';
    FlutterToast.showToast(msg: 'Waverix will turn off after $type');
    themeNotifier.setTimerSetFor(type);
  }
}
