import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/DEditScreen/edit_screen.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Buttons extends StatefulWidget {
  const Buttons({Key key, @required this.audioFnObj, @required this.index})
      : super(key: key);

  final AudioFunctions audioFnObj;
  final int index;

  @override
  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    try {
      final path = widget.audioFnObj.songs[widget.index].filePath;
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: themeNotifier.isOnlineSong
            ?
            //FOR ONLINE SONG
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //PLAY BUTTON
                  StreamBuilder<AudioPlayerState>(
                      stream: widget.audioFnObj.getState(),
                      builder: (context, snapshot) {
                        IconData playButton = FontAwesomeIcons.play;
                        if (snapshot.hasData) {
                          //Change Icon to Pause
                          if (snapshot.data == AudioPlayerState.PAUSED)
                            playButton = FontAwesomeIcons.play;

                          //Change Icon to play
                          else if (snapshot.data == AudioPlayerState.PLAYING)
                            playButton = FontAwesomeIcons.pause;
                        }
                        return Container(
                          decoration: kRaisedButtonShadow,
                          child: RaisedButton(
                            padding: EdgeInsets.all(20),
                            onPressed: () {
                              FlutterToast.showToast(
                                  msg: 'Playing Song.',
                                  toastLength: Toast.LENGTH_LONG);
                              if (playButton == FontAwesomeIcons.play) {
                                print(themeNotifier
                                        .apiData[themeNotifier.apiSelectedIndex]
                                    ['url']);
                                widget.audioFnObj.playOnlineSong(themeNotifier
                                        .apiData[themeNotifier.apiSelectedIndex]
                                    ['url']);
                              } else {
                                widget.audioFnObj.pauseLocalSong();
                              }
                            },
                            child: Icon(
                              playButton,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),

                  //REDIRECT BUTTON
                  Container(
                    decoration: kRaisedButtonShadow,
                    child: RaisedButton(
                      padding: EdgeInsets.all(20),
                      onPressed: () async {
                        final Map data = themeNotifier
                            .apiData[themeNotifier.apiSelectedIndex];
                        final String link = data['href'];
                        if (await canLaunch(link)) {
                          await launch(link);
                        } else {
                          FlutterToast.showToast(
                              msg:
                                  'Some error has occurred! Cannot redirect now');
                        }
                      },
                      child: Icon(
                        FontAwesomeIcons.externalLinkAlt,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  //DOWNLOAD BUTTON
                  Container(
                    decoration: kRaisedButtonShadow,
                    child: RaisedButton(
                      padding: EdgeInsets.all(20),
                      onPressed: () async {
                          FlutterToast.showToast(
                              msg:
                                  'Working on it. Not available in this version.');

                      },
                      child: Icon(
                        FontAwesomeIcons.download,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )

            //For Local Song
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Edit BUTTON
                  Container(
                    decoration: kRaisedButtonShadow,
                    child: RaisedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditScreen(
                                    index: widget.index,
                                  ))),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  //BACKWARD BUTTON
                  Container(
                    decoration: kRaisedButtonShadow,
                    child: RaisedButton(
                      onPressed: () => changeSong(context, widget.index - 1),
                      child: Icon(
                        FontAwesomeIcons.backward,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  //PLAY BUTTON
                  StreamBuilder<AudioPlayerState>(
                      stream: widget.audioFnObj.getState(),
                      builder: (context, snapshot) {
                        IconData playButton = FontAwesomeIcons.play;
                        if (snapshot.hasData) {
                          //Change Icon to Pause
                          if (snapshot.data == AudioPlayerState.PAUSED)
                            playButton = FontAwesomeIcons.play;

                          //Change Icon to play
                          else if (snapshot.data == AudioPlayerState.PLAYING)
                            playButton = FontAwesomeIcons.pause;
                        }
                        return Container(
                          decoration: kRaisedButtonShadow,
                          child: RaisedButton(
                            padding: EdgeInsets.all(20),
                            onPressed: () {
                              if (playButton == FontAwesomeIcons.play) {
                                widget.audioFnObj.playLocalSong(path);
                              } else {
                                widget.audioFnObj.pauseLocalSong();
                              }
                            },
                            child: Icon(
                              playButton,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),

                  //FORWARD BUTTON
                  Container(
                    decoration: kRaisedButtonShadow,
                    child: RaisedButton(
                      onPressed: () => changeSong(context, widget.index + 1),
                      child: Icon(
                        FontAwesomeIcons.forward,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  //RANDOM BUTTON
                  Container(
                    decoration: kRaisedButtonShadow,
                    child: RaisedButton(
                      onPressed: () =>
                          changeSong(context, widget.index, isRandom: true),
                      child: Icon(
                        FontAwesomeIcons.random,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
      );
    } catch (e) {
      return SizedBox();
    }
  }

  void changeSong(BuildContext context, int changeBy, {bool isRandom = false}) {
    //The variables
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final bool playList = themeNotifier.playTheList;
    Random random = Random();

    //THe playList logic
    if (playList) {
      final List<int> playListIndices = themeNotifier.listOfIndices;
      final int len = playListIndices.length - 1;
      print(len);
      int tempIndex;
      if (isRandom) {
        tempIndex = random.nextInt(playListIndices.length);
      } else {
        tempIndex = playListIndices.indexOf(widget.index);
        changeBy > widget.index
            ? tempIndex = tempIndex + 1 > len ? 0 : tempIndex + 1
            : tempIndex = tempIndex - 1 < 0 ? len : tempIndex - 1;
      }
      changeBy = playListIndices[tempIndex];
    }

    //Normal Logic
    else {
      final int totalLength =
          widget.audioFnObj.len + themeNotifier.downloadedSongs.length;
      if (isRandom) {
        changeBy = random.nextInt(totalLength);
      } else {
        if (changeBy > totalLength) {
          changeBy = 0;
        } else if (changeBy < 0) {
          changeBy = totalLength;
        }
      }
    }
    themeNotifier.setSongIndex(changeBy);
    changeBy >= widget.audioFnObj.len
        ? widget.audioFnObj
            .playLocalSong(themeNotifier.downloadedSongs[changeBy]['path'])
        : widget.audioFnObj
            .playLocalSong(widget.audioFnObj.songs[changeBy].filePath);
  }
}
