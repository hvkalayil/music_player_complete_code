import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/BHomeScreen/home_screen.dart';
import 'package:musicplayer/screens/CSelectScreen/select_screen.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    Key key,
    @required this.title,
    @required this.isHome,
  });

  final String title;
  final bool isHome;
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, HomeScreen.id);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //First Button
            DescribedFeatureOverlay(
              featureId: featureIds[1],
              onDismiss: () async {
                SavePreference.saveBool('showTour', false);
                themeNotifier.setHideList(false);
                return true;
              },
              tapTarget: Icon(
                FontAwesomeIcons.angleDown,
                color: Colors.black,
              ),
              title: Text(
                'Select Songs',
              ),
              description: Text('Tap here to go through all your songs'),
              child: Container(
                decoration: kRaisedButtonShadow,
                child: RaisedButton(
                  onPressed: () {
                    if (isHome) {
                      themeNotifier.setToggle(true);
                      Navigator.pushNamed(context, SelectScreen.id);
                    } else {
                      if (themeNotifier.selectionMode) {
                        themeNotifier.setSelectionMode(false);
                        themeNotifier.setIsRemoveFromPlaylist(false);
                      } else {
                        themeNotifier.setIsOnlineSong(false);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Icon(
                      isHome
                          ? FontAwesomeIcons.angleDown
                          : themeNotifier.selectionMode
                              ? FontAwesomeIcons.times
                              : FontAwesomeIcons.angleLeft,
                      color: Colors.white),
                ),
              ),
            ),

            //Text
            Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                //Topbar for HOME SCREEN
                isHome
                    ? themeNotifier.playTheList
                        ? Text(
                            themeNotifier.currentPlayList,
                            style: Theme.of(context).textTheme.caption,
                          )
                        : SizedBox()

                    //TopBar for SELECT SCREEN
                    : themeNotifier.isOnlineSong
                        ? SizedBox()
                        : Text(
                            'Tap & hold to get details',
                            style: Theme.of(context).textTheme.caption,
                          ),
              ],
            ),

            //Last Button
            DescribedFeatureOverlay(
              featureId: featureIds[0],
              onDismiss: () async {
                SavePreference.saveBool('showTour', false);
                themeNotifier.setHideList(false);
                return true;
              },
              tapTarget: Icon(
                FontAwesomeIcons.bars,
                color: Colors.black,
              ),
              title: Text(
                'Menu',
              ),
              description: Text('Find additional options like equalizer,'
                  ' timer or change to dark mode here'),
              child: Container(
                decoration: kRaisedButtonShadow,
                child: RaisedButton(
                  onPressed: () {
                    if (themeNotifier.selectionMode) {
                      if (themeNotifier.isRemoveFromPlaylist) {
                        batchRemoveSongs(themeNotifier.selectedIndices,
                            themeNotifier, context);
                      } else {
                        addPlaylistDialog(themeNotifier.selectedIndices,
                            themeNotifier, context);
                      }
                    } else {
                      Scaffold.of(context).openEndDrawer();
                    }
                  },
                  child: Icon(
                      themeNotifier.selectionMode
                          ? FontAwesomeIcons.check
                          : FontAwesomeIcons.bars,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
