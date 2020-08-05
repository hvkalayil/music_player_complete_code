import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayer/screens/Drawer/drawer_component.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';
import 'package:musicplayer/utilities/topbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'buttons.dart';
import 'slider.dart';
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
    return WillPopScope(
      onWillPop: () async {
        if (themeNotifier.isOnlineSong) {
          themeNotifier.setIsOnlineSong(false);
          Navigator.pop(context);
        } else {
          await dispose();
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: light,
        endDrawer: DrawerComponent(),
        body: SafeArea(
          child: FutureBuilder<int>(
              future: themeNotifier.getSongIndex(),
              initialData: 0,
              builder: (context, snapshot) {
                //Setting up file details
                index = snapshot.data;

                //Testing if any songs exist
                try {
                  if (!themeNotifier.isOnlineSong) {
                    themeNotifier.getAlbumArt(index);
                  }
                } catch (e) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TopBar(
                          title: 'HOME SCREEN',
                          isHome: true,
                        ),
                        Column(
                          children: [
                            Image.asset('assets/no_songs.png'),
                            SizedBox(height: 10),
                            FutureBuilder<bool>(
                                future: Permission.storage.isGranted,
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    if (snapshot.data)
                                      return Text(
                                        'Oops no songs found. Try downloading'
                                        ' a few or listen online.',
                                        textAlign: TextAlign.center,
                                      );
                                    else
                                      return Column(
                                        children: [
                                          Text(
                                            'Oops no songs found. It looks like'
                                            ' permissions are not granted',
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              boxShadow:
                                                  kRaisedButtonShadow.boxShadow,
                                            ),
                                            child: FlatButton(
                                              onPressed: () async {
                                                if (await Permission.storage
                                                    .isPermanentlyDenied) {
                                                  openAppSettings();
                                                } else {
                                                  if (await Permission.storage
                                                      .request()
                                                      .isGranted) {
                                                    AudioFunctions
                                                        audioFunctions =
                                                        AudioFunctions();
                                                    await audioFunctions
                                                        .getLocalSongs();
                                                    themeNotifier = Provider.of<
                                                            ThemeNotifier>(
                                                        context,
                                                        listen: false);
                                                    themeNotifier
                                                        .setAudioFunctions(
                                                            audioFunctions);
                                                    Navigator.popAndPushNamed(
                                                        context, HomeScreen.id);
                                                  }
                                                }
                                              },
                                              child: Text('Grant Permission'),
                                            ),
                                          ),
                                        ],
                                      );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          ],
                        ),
                        SizedBox()
                      ],
                    ),
                  );
                }

                //UI builder
                return Container(
                  height: deviceHeight,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [light, dark])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TopBar(
                        title: 'NOW PLAYING',
                        isHome: themeNotifier.isOnlineSong ? false : true,
                      ),
                      //ThumbNail
                      Thumbnail(
                        index: index,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //Title
                          Titles(
                            index: index,
                          ),

                          //Slider
                          SliderBar(
                            audioFnObj: audioFunctions,
                            index: index,
                          ),

                          //Buttons
                          Buttons(
                            audioFnObj: audioFunctions,
                            index: index,
                          ),
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

  //Retrieving local song details
  AudioFunctions audioFunctions = AudioFunctions();
  ThemeNotifier themeNotifier;
  @override
  void initState() {
    super.initState();
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    //TOUR
    takeTour();

    audioFunctions = themeNotifier.getAudioFunctions();
    restorePlaylistIndices();

    //Listening for song End
    if (themeNotifier.isLocal) {
      audioFunctions.audioPlayer.onPlayerCompletion.listen((event) async {
        final String type = themeNotifier.timerSetFor;
        final int index = await themeNotifier.getSongIndex();

        //If timer is not set
        if (type == '') {
          int next;
          if (themeNotifier.playTheList)
            next = index == themeNotifier.listOfIndices.last ? 0 : index + 1;
          else
            next = audioFunctions.len < index + 1 ? 0 : index + 1;

          themeNotifier.setSongIndex(next);
          audioFunctions.playLocalSong(audioFunctions.songs[next].filePath);
        }

        //If timer is set
        else {
          //Timer for song
          print(type);
          if (type == 'this song') {
            themeNotifier.setTimerSetFor('');
            await dispose();
            SystemNavigator.pop();
          }

          //Playlist
          else {
            print(index);
            print(themeNotifier.listOfIndices.last);
            if (themeNotifier.listOfIndices.last == index) {
              themeNotifier.setTimerSetFor('');
              SystemNavigator.pop();
              await dispose();
            } else {
              int next =
                  index == themeNotifier.listOfIndices.last ? 0 : index + 1;
              themeNotifier.setSongIndex(next);
              audioFunctions.playLocalSong(audioFunctions.songs[next].filePath);
            }
          }
        }
      });
    }
  }

  takeTour() async {
    final bool showTour = await SavePreference.getBool('showTour') ?? true;
    if (showTour) {
      FeatureDiscovery.clearPreferences(context, featureIds);
      FeatureDiscovery.discoverFeatures(context, featureIds);
    }
  }

  restorePlaylistIndices() async {
    if (themeNotifier.currentPlayList != '') {
      final Map<String, List<int>> data = await getPlayList();
      final List<int> indices = data[themeNotifier.currentPlayList];
      themeNotifier.setListOfIndices(indices);
    }
  }

  //Setting everything up
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

  @override
  Future<void> dispose() async {
    super.dispose();
    await audioFunctions.audioPlayer.release();
  }
}
