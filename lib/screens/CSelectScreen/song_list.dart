import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/DEditScreen/edit_screen.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/spotify_client.dart';
import 'package:provider/provider.dart';

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
  Map<int, Map> apiData;
  List<int> listOfIndices;
  @override
  void initState() {
    super.initState();
    localSongs = widget.audioFunctions.songs;
    listOfIndices = List<int>.generate(localSongs.length, (index) => index);
  }

  double width, height;
  ThemeNotifier themeNotifier;
  String currentSong;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    getName();
  }

  Future<void> getName() async => currentSong = await themeNotifier
      .getSongIndex()
      .then((value) => themeNotifier.getAlbumTitle(value));
  String query = '';
  final myController = TextEditingController();

  //Build
  @override
  Widget build(BuildContext context) {
    return Column(children: [makeSearchBar(), makeSongList()]);
  }

  //Search Bar
  bool isLocal = true;
  Container makeSearchBar() {
    return Container(
      margin: EdgeInsets.all(20),
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

        //DECORATION
        decoration: InputDecoration(
            prefixIcon: Icon(FontAwesomeIcons.search),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isLocal = !isLocal;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 30),
                child: Icon(
                    isLocal ? FontAwesomeIcons.file : FontAwesomeIcons.wifi),
              ),
            ),
            labelText: isLocal ? 'Search Files' : 'Search Online',
            border: InputBorder.none),

        //Local Search
        onChanged: (v) async {
          final query = v.toLowerCase();
          List<int> temp = [];

          if (isLocal) {
            for (int i = 0; i < localSongs.length; i++) {
              if (localSongs[i].title.toLowerCase().contains(query)) {
                temp.add(i);
              }
            }
            setState(() {
              listOfIndices = temp;
            });
          }
        },

        //Api Search
        onEditingComplete: () async {
          final query = myController.text.toLowerCase();
          const int limit = 30;
          List<int> temp = [];
          if (!isLocal) {
            Map<int, Map> data = await SpotifyAPI.getData(query, limit);
            temp = List<int>.generate(data.length, (index) => index);
            setState(() {
              apiData = data;
              listOfIndices = temp;
            });
          }
        },
      ),
    );
  }

  //List of items
  Container makeSongList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      child: ListView.builder(
        primary: true,
        shrinkWrap: true,
        itemCount: listOfIndices.length,
        itemBuilder: (context, index) => makeSongListItem(context, index),
      ),
    );
  }

  //Each List Item
  Widget makeSongListItem(BuildContext context, int listIndex) {
    final int index = listOfIndices[listIndex];
    String title, artist;
    if (isLocal) {
      title = localSongs[index].title;
      artist = localSongs[index].artist;
    } else {
      try {
        title = apiData[index]['title'];
        artist = apiData[index]['artist'];
      } catch (e) {
        return CircularProgressIndicator();
      }
    }

    // ignore: missing_required_param
    return FocusedMenuHolder(
      animateMenuItems: true,
      menuItems:
          menuItems.entries.map((e) => makeMenuItems(e.value, index)).toList(),
      child: ListTile(
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
                  widget.audioFunctions.playLocalSong(
                      widget.audioFunctions.songs[index].filePath);
                  themeNotifier.setSongIndex(index);
                  Navigator.pop(context);
                },
                child: Column(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Menu Options
  Map<int, Map> menuItems = {
    0: {'title': 'Edit Details', 'icon': FontAwesomeIcons.edit},
  };
  //Making menu Options
  FocusedMenuItem makeMenuItems(Map data, int index) {
    return FocusedMenuItem(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(data['title']),
        trailingIcon: Icon(
          data['icon'],
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          //Edit Details
          if (data['title'] == 'Edit Details') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditScreen(
                          index: index,
                        )));
          }
        });
  }
}
