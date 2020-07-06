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
    final String title = themeNotifier.getAlbumTitle(index);
    final String artist = themeNotifier.getAlbumArtist(index);

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
