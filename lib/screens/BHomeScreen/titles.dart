import 'package:flutter/material.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class Titles extends StatelessWidget {
  const Titles({Key key, @required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    //Setting everything
    double deviceWidth = MediaQuery.of(context).size.width;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    String title;
    if (themeNotifier.isOnlineSong) {
      title = themeNotifier.apiData[themeNotifier.apiSelectedIndex]['title'];
    } else {
      title = index >= themeNotifier.getAudioFunctions().len
          ? themeNotifier.downloadedSongs[index]['title']
          : themeNotifier.getAlbumTitle(index);
    }

    String artist;
    if (themeNotifier.isOnlineSong) {
      artist = themeNotifier.apiData[themeNotifier.apiSelectedIndex]['artist'];
    } else {
      artist = index >= themeNotifier.getAudioFunctions().len
          ? themeNotifier.downloadedSongs[index]['artist']
          : themeNotifier.getAlbumArtist(index);
    }

    //UI
    return Column(
      children: [
        SizedBox(
          width: deviceWidth * 0.75,
          child: Text(
            title,
            softWrap: false,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        SizedBox(
          width: deviceWidth * 0.65,
          child: Text(
            artist,
            softWrap: false,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ],
    );
  }
}
