import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/screens/Drawer/drawer_component.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/topbar.dart';
import 'package:provider/provider.dart';

import 'song_list.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({Key key}) : super(key: key);
  static String id = 'SelectScreen id';

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  //Initializing everything
  ThemeNotifier themeNotifier;
  AudioFunctions audioFunctions;
  @override
  void initState() {
    super.initState();
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    audioFunctions = themeNotifier.getAudioFunctions();
    final int downloadedSongslength = themeNotifier.downloadedSongs.length;
    List<int> temp =
        List<int>.generate(audioFunctions.len + downloadedSongslength, (index) {
      int returnValue;
      if (index < downloadedSongslength) {
        returnValue = audioFunctions.len + index;
      } else {
        returnValue = index - downloadedSongslength;
      }
      return returnValue;
    });
    themeNotifier.setListOfIndices(temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      endDrawer: DrawerComponent(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: deviceHeight,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [light, dark])),
            child: Column(
              children: [
                TopBar(
                  title: 'SELECT',
                  isHome: false,
                ),
                SongList(
                  audioFunctions: audioFunctions,
                  songs: audioFunctions.songs,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Changing visuals on change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setupVisualResources();
  }

  //Setting visual resources
  double deviceHeight;
  Color light, dark;
  setupVisualResources() {
    deviceHeight = MediaQuery.of(context).size.height;
    light = Theme.of(context).primaryColorLight;
    dark = Theme.of(context).primaryColorDark;
  }
}
