import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        padding: EdgeInsets.all(20),
        color: Theme.of(context).secondaryHeaderColor,
        child: ListView(
          children: [
            Text('OPTIONS',
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center),
            SizedBox(height: 10),
            Column(
              children: [
                Column(
                  children: menuItems.entries
                      .map((e) => makeMenuItems(e.key, e.value, context))
                      .toList(),
                ),
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
        onPressed: () {},
        child: Row(
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
}
