import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/BHomeScreen/home_screen.dart';
import 'package:musicplayer/screens/DEditScreen/edit_screen.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/download_audio.dart';
import 'package:musicplayer/utilities/google_ads.dart';
import 'package:provider/provider.dart';

class SongListView extends StatefulWidget {
  const SongListView({Key key, @required this.localSongs, this.audioFunctions})
      : super(key: key);
  final List<SongInfo> localSongs;
  final AudioFunctions audioFunctions;

  @override
  _SongListViewState createState() => _SongListViewState();
}

class _SongListViewState extends State<SongListView> {
  ThemeNotifier themeNotifier;
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    isSelected = List<bool>.generate(
        themeNotifier.listOfIndices.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return themeNotifier.isNotListening
        ? themeNotifier.listOfIndices.isNotEmpty
            ? Container(
                height: themeNotifier.toggle
                    ? MediaQuery.of(context).size.height * 0.7
                    : MediaQuery.of(context).size.height * 0.5,
                child: RefreshIndicator(
                  onRefresh: () async {
                    Map<int, Map> newSongs = await getDownloadedSongs();
                    themeNotifier.setDownloadedSongs(newSongs);
                  },
                  child: FutureBuilder<bool>(
                      future: themeNotifier.getHideList(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return snapshot.data
                              ? SizedBox()
                              : ListView.builder(
                                  primary: true,
                                  shrinkWrap: true,
                                  itemCount: themeNotifier.listOfIndices.length,
                                  itemBuilder: (context, index) =>
                                      makeSongListItem(context, index),
                                );
                        } else {
                          return SizedBox();
                        }
                      }),
                ),
              )
            : Text('No Songs here')
        : Column(
            children: [CircularProgressIndicator(), Text('Enter song name')],
          );
  }

  //Context menu Options
  Map<int, Map> menuItemsNormal = {
    0: {'title': 'Edit Details', 'icon': FontAwesomeIcons.edit},
    1: {'title': 'Add to Playlist', 'icon': FontAwesomeIcons.plusSquare},
    2: {'title': 'Select Song', 'icon': FontAwesomeIcons.check}
  };
  Map<int, Map> menuItemsPlaylist = {
    0: {'title': 'Edit Details', 'icon': FontAwesomeIcons.edit},
    1: {'title': 'Remove from playlist', 'icon': FontAwesomeIcons.minusSquare},
    2: {'title': 'Select Songs to remove', 'icon': FontAwesomeIcons.check}
  };

  //List Item builder
  Widget makeSongListItem(BuildContext context, int listIndex) {
    double width = MediaQuery.of(context).size.width;
    final int lstIndex = themeNotifier.listOfIndices[listIndex];
    String url = '';
    String title, artist;

    //Trying to get song Details
    try {
      if (themeNotifier.isLocal) {
        if (lstIndex >= widget.audioFunctions.len) {
          title = themeNotifier.downloadedSongs[lstIndex]['title'];
          artist = themeNotifier.downloadedSongs[lstIndex]['artist'];
        } else {
          title = widget.localSongs[lstIndex].title;
          artist = widget.localSongs[lstIndex].artist;
        }
      } else {
        title = themeNotifier.apiData[lstIndex]['title'];
        artist = themeNotifier.apiData[lstIndex]['artist'];
        url = themeNotifier.apiData[lstIndex]['url'];
      }
    } catch (e) {
      return SizedBox();
    }

    //Checking if details are valid
    if (title == null || artist == null) {
      if (listIndex == themeNotifier.listOfIndices.length) {
        return Text('No Data found');
      } else {
        return SizedBox();
      }
    }

    //Building the UI
    else {
      // ignore: missing_required_param
      return FocusedMenuHolder(
        animateMenuItems: true,
        menuItems: themeNotifier.isLocal
            ? themeNotifier.toggle
                ? menuItemsNormal.entries
                    .map((e) => makeMenuItems(e.value, lstIndex, context))
                    .toList()
                : menuItemsPlaylist.entries
                    .map((e) => makeMenuItems(e.value, lstIndex, context))
                    .toList()
            : [],
        child: ListTile(
          onTap: () => onListItemClicked(lstIndex),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * 0.7,
                      child: Text(
                        title,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.6,
                      child: Text(
                        artist,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    )
                  ],
                ),
                themeNotifier.selectionMode
                    ? Icon(isSelected[lstIndex]
                        ? FontAwesomeIcons.solidCircle
                        : FontAwesomeIcons.circleNotch)
                    : SizedBox()
              ],
            ),
          ),
        ),
      );
    }
  }

  //Part of List item builder
  Future<void> onListItemClicked(int lstIndex) async {
    final List<int> selIndices = themeNotifier.selectedIndices;

    //Selecting song - if toggle is ON
    if (themeNotifier.selectionMode) {
      setState(() {
        isSelected[lstIndex] = !isSelected[lstIndex];
      });

      //Inserting if index doesnot exist
      if (isSelected[lstIndex]) {
        if (!selIndices.contains(lstIndex)) {
          selIndices.add(lstIndex);
        }
      }

      //Deleting if index  exist
      else {
        if (selIndices.contains(lstIndex)) {
          selIndices.remove(lstIndex);
        }
      }

      //Saving list
      themeNotifier.setSelectedIndices(selIndices);
    }

    //Playing Song
    else {
      themeNotifier.setPlayTheList(false);
      themeNotifier.setCurrentPlayList('');
      //Local
      if (themeNotifier.isLocal) {
        if (lstIndex >= widget.audioFunctions.len) {
          widget.audioFunctions
              .playLocalSong(themeNotifier.downloadedSongs[lstIndex]['path']);
          themeNotifier.setSongIndex(lstIndex);
        } else {
          widget.audioFunctions
              .playLocalSong(widget.audioFunctions.songs[lstIndex].filePath);
          themeNotifier.setSongIndex(lstIndex);
        }

        Navigator.pop(context);
      }

      //Online
      else {
        FlutterToast.showToast(
            msg: 'Getting Details', toastLength: Toast.LENGTH_LONG);

        //Showing Ad
        Random r = Random();
        final bool show = r.nextBool();

        if (show) {
          _createInterstitalAd();
          _interstitialAd..show();
        }

        //Retrieving art and link
        DownloadAudio object = DownloadAudio();
        final Map newData =
            await object.getArtAndLink(themeNotifier.apiData[lstIndex]);
        final Map<int, Map> data = themeNotifier.apiData;
        data[lstIndex] = newData;
        themeNotifier.setApiData(data);

        //Setting up
        themeNotifier.setIsOnlineSong(true);
        themeNotifier.setApiSelectedIndex(lstIndex);

        if (!show) Navigator.pushNamed(context, HomeScreen.id);
      }
    }
  }

  //Context Menu Builder
  FocusedMenuItem makeMenuItems(Map data, int index, BuildContext context) {
    return FocusedMenuItem(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(data['title']),
        trailingIcon: Icon(
          data['icon'],
          color: Theme.of(context).accentColor,
        ),
        onPressed: () => onContextMenuClick(data, index));
  }

  //Part of Context Menu Builder
  Future<void> onContextMenuClick(Map data, int index) async {
    {
      //Edit Details
      if (data['title'] == 'Edit Details') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditScreen(
                      index: index,
                    )));
      }

      //Add to PlayList
      else if (data['title'] == 'Add to Playlist') {
        addPlaylistDialog([index], themeNotifier, context);
      }

      //Select Song
      else if (data['title'] == 'Select Song') {
        themeNotifier.setSelectionMode(true);
        themeNotifier.setSelectedIndices([index]);
        setState(() {
          isSelected[index] = !isSelected[index];
        });
      }

      //Remove from playlist
      else if (data['title'] == 'Remove from playlist') {
        final Map<String, List<int>> data = await getPlayList();
        data[themeNotifier.currentPlayList].remove(index);
        final List<int> newList = data[themeNotifier.currentPlayList];
        themeNotifier.setListOfIndices(newList);
        savePlayLists(data);
      }

      //Batch Remove
      else if (data['title'] == 'Select Songs to remove') {
        themeNotifier.setIsRemoveFromPlaylist(true);
        themeNotifier.setSelectionMode(true);
        themeNotifier.setSelectedIndices([index]);
        setState(() {
          isSelected[index] = !isSelected[index];
        });
      }
    }
  }

  //INTERSTITAL AD
  InterstitialAd _interstitialAd;

  void _createInterstitalAd() {
    _interstitialAd = InterstitialAd(
        adUnitId: AdManager.interstitialAdUnitId,
        targetingInfo: targetingInfo,
        listener: (event) => _onInterstitialAdEvent(event));
    _interstitialAd..load();
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.closed:
        Navigator.pushNamed(context, HomeScreen.id);
        break;
      default:
      // do nothing
    }
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd.dispose();
  }
}
