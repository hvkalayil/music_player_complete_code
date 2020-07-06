import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/screens/BHomeScreen/slider.dart';
import 'package:musicplayer/screens/Drawer/drawer_component.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/topbar.dart';
import 'package:provider/provider.dart';

import 'buttons.dart';
import 'thumbnail.dart';
import 'titles.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: light,
      endDrawer: DrawerComponent(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<int>(
              future: themeNotifier.getSongIndex(),
              initialData: 0,
              builder: (context, snapshot) {
                //Setting up file details
                index = snapshot.data;

                //UI builder
                return Container(
                  height: deviceHeight,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [light, dark])),
                  child: Column(
                    children: [
                      TopBar(
                        title: 'NOW PLAYING',
                        isHome: true,
                      ),
                      Column(
                        children: [
                          //ThumbNail
                          Thumbnail(
                            index: index,
                          ),

                          //Title
                          Titles(
                            index: index,
                          ),

                          //Slider
                          SliderBar(
                            audioFnObj: audioFunctions,
                            index: index,
                          ),
                          SizedBox(height: 20),

                          //Buttons
                          Buttons(
                            audioFnObj: audioFunctions,
                            index: index,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  //Setting everything up
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setupVisualResources();
    getSongDetails();
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
  ThemeNotifier themeNotifier;
  void getSongDetails() async {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    audioFunctions = themeNotifier.getAudioFunctions();
  }
}
