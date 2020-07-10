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
  ThemeNotifier themeNotifier; //Provider Variable

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setupVisualResources();
    getSongDetails(); //Function to retrieve local audio files & details
  }

  //Setting visual resources
  double deviceHeight;
  Color light, dark;
  setupVisualResources() {
    deviceHeight = MediaQuery.of(context).size.height;
    light = Theme.of(context).primaryColorLight;
    dark = Theme.of(context).primaryColorDark;
  }

  //Retrieving local song details
  AudioFunctions audioFunctions = AudioFunctions();
  void getSongDetails() async {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: true);
    audioFunctions = themeNotifier.getAudioFunctions();
  }

  String query;

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
}
