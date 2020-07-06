import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/constants.dart';

class SongList extends StatelessWidget {
  const SongList({
    Key key,
    @required this.themeNotifier,
    @required this.listHeight,
    @required this.audioFunctions,
  }) : super(key: key);

  final ThemeNotifier themeNotifier;
  final double listHeight;
  final AudioFunctions audioFunctions;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: audioFunctions.songs != null
            ? ListView.builder(
                primary: true,
                shrinkWrap: true,
                itemCount: audioFunctions.len,
                itemBuilder: (context, index) =>
                    makeSongList(context, index, themeNotifier),
              )
            : SizedBox(),
      ),
    );
  }

  Widget makeSongList(BuildContext context, int index, ThemeNotifier notifier) {
    String title = audioFunctions.songs[index].title;
    String artist = audioFunctions.songs[index].artist;

    return ListTile(
      title: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.white12,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(-5, -8)),
              BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(5, 8))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                audioFunctions
                    .playLocalSong(audioFunctions.songs[index].filePath);
                notifier.setSongIndex(index);
                Navigator.pop(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      title,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      artist,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: raisedButtonShadow,
              child: RaisedButton(
                onPressed: () {},
                child: Icon(
                  FontAwesomeIcons.heart,
                  color: Theme.of(context).cardColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
