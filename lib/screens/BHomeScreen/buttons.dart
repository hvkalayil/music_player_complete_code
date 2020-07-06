import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/DEditScreen/edit_screen.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:provider/provider.dart';

class Buttons extends StatelessWidget {
  const Buttons({Key key, @required this.audioFnObj, @required this.index})
      : super(key: key);

  final AudioFunctions audioFnObj;
  final int index;

  @override
  Widget build(BuildContext context) {
    try {
      final path = audioFnObj.songs[index].filePath;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //Edit BUTTON
          Container(
            decoration: raisedButtonShadow,
            child: RaisedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditScreen(
                            index: index,
                          ))),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),

          //BACKWARD BUTTON
          Container(
            decoration: raisedButtonShadow,
            child: RaisedButton(
              onPressed: () => changeSong(context, index - 1),
              child: Icon(
                FontAwesomeIcons.backward,
                color: Colors.white,
              ),
            ),
          ),

          //PLAY BUTTON
          StreamBuilder<AudioPlayerState>(
              stream: audioFnObj.getState(),
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
                  decoration: raisedButtonShadow,
                  child: RaisedButton(
                    padding: EdgeInsets.all(20),
                    onPressed: () {
                      if (playButton == FontAwesomeIcons.play) {
                        audioFnObj.playLocalSong(path);
                      } else {
                        audioFnObj.pauseLocalSong();
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
            decoration: raisedButtonShadow,
            child: RaisedButton(
              onPressed: () => changeSong(context, index + 1),
              child: Icon(
                FontAwesomeIcons.forward,
                color: Colors.white,
              ),
            ),
          ),

          //RANDOM BUTTON
          Container(
            decoration: raisedButtonShadow,
            child: RaisedButton(
              onPressed: () => changeSong(context, index, isRandom: true),
              child: Icon(
                FontAwesomeIcons.random,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      return SizedBox();
    }
  }

  void changeSong(BuildContext context, int changeBy, {bool isRandom = false}) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    if (isRandom) {
      Random random = Random();
      changeBy = random.nextInt(audioFnObj.len);
    }
    if (changeBy > audioFnObj.len) {
      changeBy = 0;
    } else if (changeBy < 0) {
      changeBy = audioFnObj.len;
    }
    themeNotifier.setSongIndex(changeBy);
    audioFnObj.playLocalSong(audioFnObj.songs[changeBy].filePath);
  }
}
