import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/CSelectScreen/search_bar.dart';
import 'package:musicplayer/screens/CSelectScreen/song_listview.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'playlist_view.dart';

class SongList extends StatefulWidget {
  const SongList({Key key, @required this.audioFunctions, @required this.songs})
      : super(key: key);

  final AudioFunctions audioFunctions;
  final List<SongInfo> songs;

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  List<SongInfo> localSongs;

  @override
  void initState() {
    super.initState();
    localSongs = widget.audioFunctions.songs;
  }

  bool toggle = true;
  //Build
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Container(
            decoration: kRaisedButtonShadow,
            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: RaisedButton(
                onPressed: () {
                  setState(() {
                    toggle = !toggle;
                  });
                  final themeNotifier =
                      Provider.of<ThemeNotifier>(context, listen: false);
                  if (toggle) {
                    List<int> temp = List<int>.generate(
                        widget.audioFunctions.len, (index) => index);
                    themeNotifier.setListOfIndices(temp);
                    themeNotifier.setToggle(toggle);
                  } else {
                    themeNotifier.setSelectionMode(false);
                  }
                },
                child: DescribedFeatureOverlay(
                  backgroundOpacity: 0,
                  contentLocation: ContentLocation.below,
                  featureId: featureIds[2],
                  onDismiss: () async {
                    SavePreference.saveBool('showTour', false);
                    final themeNotifier =
                        Provider.of<ThemeNotifier>(context, listen: false);
                    themeNotifier.setHideList(false);
                    return true;
                  },
                  onComplete: () async {
                    final themeNotifier =
                        Provider.of<ThemeNotifier>(context, listen: false);
                    themeNotifier.setHideList(false);
                    return true;
                  },
                  tapTarget: Icon(
                    FontAwesomeIcons.search,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Search / PlayList',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  description: Text(
                    'Toggle between search mode and playlists',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  child: Icon(
                      toggle ? FontAwesomeIcons.search : FontAwesomeIcons.list),
                )),
          ),
          toggle ? SearchBar(localSongs: localSongs) : PlayListView()
        ],
      ),
      SongListView(
        localSongs: localSongs,
        audioFunctions: widget.audioFunctions,
      )
    ]);
  }
}
