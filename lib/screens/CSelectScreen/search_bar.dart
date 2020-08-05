import 'package:connectivity/connectivity.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/download_audio.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key key, @required this.localSongs}) : super(key: key);
  final List<SongInfo> localSongs;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        boxShadow: [
          BoxShadow(
              color: Colors.white.withAlpha(100),
              blurRadius: 8,
              offset: Offset(-5, -5)),
          BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 8,
              offset: Offset(5, 5))
        ],
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: TextFormField(
        controller: myController,
        style: Theme.of(context).textTheme.headline6,
        textInputAction: TextInputAction.search,

        //DECORATION
        decoration: InputDecoration(
            suffixIcon: DescribedFeatureOverlay(
              onOpen: () async {
                final themeNotifier =
                    Provider.of<ThemeNotifier>(context, listen: false);
                SavePreference.saveBool('showTour', false);
                themeNotifier.setHideList(false);
                return true;
              },
              contentLocation: ContentLocation.below,
              featureId: featureIds[3],
              tapTarget: Icon(
                FontAwesomeIcons.file,
                color: Colors.black,
              ),
              title: Text(
                'Search Online / Offline',
                style: TextStyle(color: Colors.white),
              ),
              description: Text(
                'Toggle between search modes and find your songs easy.',
                style: TextStyle(color: Colors.white),
              ),
              child: GestureDetector(
                onTap: () {
                  themeNotifier.setIsLocal(!themeNotifier.isLocal);
                  themeNotifier.setIsNotListening(false);
                },
                child: Icon(themeNotifier.isLocal
                    ? FontAwesomeIcons.file
                    : FontAwesomeIcons.wifi),
              ),
            ),
            labelText: themeNotifier.isLocal ? 'Search Files' : 'Search Online',
            border: InputBorder.none),

        //Local Search
        onChanged: (v) async {
          final query = v.toLowerCase();
          List<int> temp = [];

          if (themeNotifier.isLocal) {
            for (int i = 0; i < widget.localSongs.length; i++) {
              if (widget.localSongs[i].title.toLowerCase().contains(query)) {
                temp.add(i);
              }
            }
            themeNotifier.setListOfIndices(temp);
          }
        },

        //Api Search
        onEditingComplete: () async {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          themeNotifier.setIsNotListening(true);
          final query = myController.text.toLowerCase();
          List<int> temp = [];
          if (!themeNotifier.isLocal) {
            //Checking conection
            var conn = await Connectivity().checkConnectivity();
            if (conn == ConnectivityResult.none) {
              FlutterToast.showToast(
                  msg: 'Please enable network and try again');
              return;
            }
            FlutterToast.showToast(
                msg: 'Searching', toastLength: Toast.LENGTH_LONG);
            DownloadAudio object = DownloadAudio();
            Map<int, Map> data = await object.search(query);
            temp = List<int>.generate(data.length, (index) => index);

            themeNotifier.setApiData(data);
            themeNotifier.setListOfIndices(temp);
          }
        },
      ),
    );
  }
}
