import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';

List<String> featureIds = [
  'Drawer',
  'SelectSongs Button',
  'Search Button Toggle',
  'Online Offline Search Toggle',
  'Song Item'
];

final Map<IconData, String> kMenuItems = {
  FontAwesomeIcons.slidersH: 'EQUALIZER',
  FontAwesomeIcons.directions: 'TAKE A TOUR',
  FontAwesomeIcons.info: 'ABOUT',
  FontAwesomeIcons.clock: 'SET TIMER'

//  FontAwesomeIcons.download: 'DEFAULT PATH'
};

final BoxDecoration kRaisedButtonShadow = BoxDecoration(
  shape: BoxShape.circle,
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
);

Future<List<String>> kGetKeys() async {
  final String keys = await rootBundle.loadString('secrets.json');
  List<String> _keys = [];
  _keys.add(keys.split('"')[3]);
  _keys.add(keys.split('"')[7]);
  return _keys;
}

void savePlayLists(Map<String, List<int>> data) async {
  List<String> names = [];
  List<String> indices = [];
  List<int> range = [];

  //Parsing data into lists
  data.forEach((key, value) {
    names.add(key);
    value.forEach((element) => indices.add(element.toString()));
    range.add(value.length);
  });

  //Converting lists to string to store
  List<String> ranges = [];
  range.forEach((element) => ranges.add(element.toString()));

  //Storing
  SavePreference.saveStringList('playlistNames', names);
  SavePreference.saveStringList('playlistIndices', indices);
  SavePreference.saveStringList('playlistRange', ranges);
}

Future<Map<String, List<int>>> getPlayList() async {
  Map<String, List<int>> data = {};
  try {
    //Getting lists from storage
    final List<String> names =
        await SavePreference.getStringList('playlistNames') ??
            <String>['Favourites'];
    final List<String> indices =
        await SavePreference.getStringList('playlistIndices') ?? <String>[];
    List<int> index = [];
    indices.forEach((element) => index.add(int.parse(element)));

    final List<String> ranges =
        await SavePreference.getStringList('playlistRange') ?? <String>['0'];
    List<int> range = [];
    ranges.forEach((element) => range.add(int.parse(element)));

    //Making MAP
    for (int i = 0; i < range.length; i++) {
      List<int> selected = [];
      int startingIndex = 0;
      if (i != 0) startingIndex = range[i - 1];

      for (int j = startingIndex; j < startingIndex + range[i]; j++)
        selected.add(index[j]);

      data.addAll({names[i]: selected});
    }
  } catch (e) {
    //Returning ERROR Map if error occurs
    //Or if there is no playlist
    print(e.toString());
    data.addAll(errorMap);
  }
  print(data);
  return data;
}

Map<String, List<int>> errorMap = {
  'ERROR': [404]
};

void addPlaylistDialog(
    List<int> indices, ThemeNotifier themeNotifier, BuildContext context) {
  bool mode = true;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<String> theList = themeNotifier.listOfPlaysLists;
  final int index = indices[0] ?? 0;
  showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                //TITLE
                title: Column(
                  children: [
                    Center(
                        child: Text(
                      'Select PlayList',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1,
                    )),
                    Divider()
                  ],
                ),

                //BODY
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SwitchListTile(
                        value: mode,
                        onChanged: (v) {
                          print(v);
                          setState(() {
                            mode = !mode;
                          });
                        },
                        title: Text('Use Existing PlayList')),
                    mode
                        ? DropdownButton<String>(
                            value: themeNotifier.currentPlayList == ''
                                ? 'Favourites'
                                : themeNotifier.currentPlayList,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 12,
                            elevation: 8,
                            items: theList
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) =>
                                themeNotifier.setCurrentPlayList(value),
                          )
                        : Form(
                            key: _key,
                            child: TextFormField(
                              // ignore: missing_return
                              validator: (v) {
                                if (v.isEmpty) {
                                  return 'Enter Playllist Name';
                                } else if (theList.contains(v)) {
                                  return 'This PlayList already exists.';
                                }
                              },
                              textInputAction: TextInputAction.done,

                              //DECORATION
                              decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.plus),
                                  labelText: 'Create New PlayList',
                                  border: InputBorder.none),

                              //FINISH
                              onSaved: (input) async {
                                theList.add(input);
                                themeNotifier.setListOfPlayLists(theList);
                                final Map<String, List<int>> data =
                                    await getPlayList();
                                data.addAll({input: indices});
                                savePlayLists(data);
                              },
                            ),
                          ),
                  ],
                ),

                //ACTIONS
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('CANCEL')),
                  FlatButton(
                      onPressed: () async {
                        //EXISTING
                        if (mode) {
                          final Map<String, List<int>> data =
                              await getPlayList();

                          //GROUP SELECTION
                          if (themeNotifier.selectionMode) {
                            if (indices.isEmpty) {
                              FlutterToast.showToast(
                                  msg: 'Select at least one song');
                            } else {
                              indices.forEach((element) {
                                if (!data[themeNotifier.currentPlayList]
                                    .contains(element)) {
                                  data[themeNotifier.currentPlayList]
                                      .add(element);
                                }
                              });
                            }
                          }

                          //SINGLE SELECTION
                          else {
                            if (data[themeNotifier.currentPlayList]
                                .contains(index)) {
                              FlutterToast.showToast(
                                  msg: 'This song is already in the playlist');
                            } else {
                              data[themeNotifier.currentPlayList].add(index);
                            }
                          }
                          savePlayLists(data);
                        }

                        //NEW PLAYLIST
                        else {
                          final FormState _state = _key.currentState;
                          if (_state.validate()) {
                            _state.save();
                          }
                        }

                        themeNotifier.setSelectionMode(false);
                        Navigator.pop(context);
                      },
                      child: Text('DONE'))
                ],
              );
            },
          ));
}

void batchRemoveSongs(
    List<int> indices, ThemeNotifier themeNotifier, BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            //TITLE
            title: Column(
              children: [
                Center(
                    child: Text(
                  'Confirm Removal',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                )),
                Divider()
              ],
            ),

            content: Text('Are you sure you want to delete ${indices.length} '
                'songs from ${themeNotifier.currentPlayList}'),
            //ACTIONS
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCEL')),
              FlatButton(
                  onPressed: () async {
                    if (indices.isEmpty) {
                      FlutterToast.showToast(msg: 'Select at least one song');
                    } else {
                      final Map<String, List<int>> data = await getPlayList();
                      indices.forEach((element) {
                        if (data[themeNotifier.currentPlayList]
                            .contains(element)) {
                          data[themeNotifier.currentPlayList].remove(element);
                        }
                      });
                      themeNotifier.setIsRemoveFromPlaylist(false);
                      themeNotifier.setSelectionMode(false);
                      FlutterToast.showToast(
                          msg: 'Songs removed from Playlist');
                    }
                    Navigator.pop(context);
                  },
                  child: Text('REMOVE'))
            ],
          ));
}

Future<Map<int, Map>> getDownloadedSongs() async {
  List<String> tempIndicesString =
      await SavePreference.getStringList('downloadedIndices') ?? [];
  List<String> tempTitles =
      await SavePreference.getStringList('downloadedTitle') ?? [];
  List<String> tempArtist =
      await SavePreference.getStringList('downloadedArtist') ?? [];
  List<String> tempArt =
      await SavePreference.getStringList('downloadedArt') ?? [];
  List<String> tempPath =
      await SavePreference.getStringList('downloadedPath') ?? [];

  List<int> tempIndicesInt = [];
  tempIndicesString
      .forEach((element) => tempIndicesInt.add(int.parse(element)));

  Map<int, Map> downloadedSongs = {};
  for (int i = 0; i < tempIndicesString.length; i++) {
    downloadedSongs.addAll({
      tempIndicesInt[i]: {
        'title': tempTitles[i],
        'artist': tempArtist[i],
        'art': tempArt[i],
        'path': tempPath[i],
      }
    });
  }
  return downloadedSongs;
}

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['Music', 'MusicPlayer', 'Free Songs', 'Songs'],
    testDevices: ['Mobile id'],
    nonPersonalizedAds: true);
