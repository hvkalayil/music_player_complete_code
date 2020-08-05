import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class Thumbnail extends StatelessWidget {
  const Thumbnail({Key key, @required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    //Setting everything
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    String path = 'assets/thumbnail.jpg';
    if (!themeNotifier.isOnlineSong) {
      if (index >= themeNotifier.getAudioFunctions().len)
        path = themeNotifier.downloadedSongs[index]['art'];
      else
        path = themeNotifier.getAlbumArt(index);
    }

    final dark = Theme.of(context).primaryColorDark;
    final light = Theme.of(context).primaryColorLight;

    //UI
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width - 100,
      height: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [dark, light]),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dark,
          boxShadow: [
            BoxShadow(
                color: Colors.white.withAlpha(100),
                blurRadius: 16,
                offset: Offset(-9, -9)),
            BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 16,
                offset: Offset(9, 9))
          ],
          image: DecorationImage(
            image: themeNotifier.isOnlineSong
                ? NetworkImage(themeNotifier
                    .apiData[themeNotifier.apiSelectedIndex]['art'])
                : loadThumbNail(File(path)),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  ImageProvider loadThumbNail(File f) =>
      f.existsSync() ? FileImage(f) : AssetImage('assets/thumbnail.jpg');
}
