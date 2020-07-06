import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/BHomeScreen/thumbnail.dart';
import 'package:musicplayer/screens/DEditScreen/online_art.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'local_art.dart';

class EditScreen extends StatefulWidget {
  static String id = 'EditScreen';
  const EditScreen({Key key, @required this.index});

  final int index;
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    savingOriginalDetails();
  }

  //Saving to repopulate details onCancel
  void savingOriginalDetails() {
    SavePreference.saveString(
        'albumArt', themeNotifier.getAlbumArt(widget.index));
    SavePreference.saveString(
        'albumTitle', themeNotifier.getAlbumTitle(widget.index));
    SavePreference.saveString(
        'albumArtist', themeNotifier.getAlbumArtist(widget.index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [light, dark])),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //TOP BAR
                  editTopBar(),

                  //Thumbnail
                  Thumbnail(
                    index: widget.index,
                  ),

                  //Change Thumbnail
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      LocalArt(
                        index: widget.index,
                      ),
                      OnlineArt(
                        index: widget.index,
                      ),
                    ],
                  ),

                  //Change Song Title
                  editSongDetails(themeNotifier.getAlbumTitle(widget.index),
                      'Change Song Title'),

                  //Change Song Author
                  editSongDetails(themeNotifier.getAlbumArtist(widget.index),
                      'Change Song Artist'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  editTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: raisedButtonShadow,
            child: RaisedButton(
              onPressed: () async {
                //Retrieving
                final String originalArt =
                    await SavePreference.getString('albumArt');
                final String originalTitle =
                    await SavePreference.getString('albumTitle');
                final String originalArtist =
                    await SavePreference.getString('albumArtist');

                //Repopulating
                themeNotifier.setArt(originalArt, widget.index);
                themeNotifier.setArt(originalTitle, widget.index);
                themeNotifier.setArt(originalArtist, widget.index);

                Navigator.pop(context);
              },
              child: Icon(
                FontAwesomeIcons.times,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            'Edit Details',
            style: Theme.of(context).textTheme.headline1,
          ),
          Container(
            decoration: raisedButtonShadow,
            child: RaisedButton(
              onPressed: () async {
                final _formState = _formKey.currentState;
                if (_formState.validate()) {
                  _formState.save();

                  //Storing changes to local
                  List<SongInfo> localSongs = _audioFunctions.songs;
                  final Map<int, List<SongInfo>> songsMap = {1: localSongs};
                  final String encodedJson = json.encode(songsMap);
                  SavePreference.saveString('LocalSongs', encodedJson);
                  SavePreference.saveInt(
                      'LocalSongsLength', _audioFunctions.len);

                  Navigator.pop(context);
                }
              },
              child: Icon(
                FontAwesomeIcons.check,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _newTitle, _newArtist;
  editSongDetails(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
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
        color: light,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: TextFormField(
        // ignore: missing_return
        validator: (input) {
          if (input.isEmpty) return 'This field should not be empty';
        },
        initialValue: value,
        style: Theme.of(context).textTheme.headline6,
        decoration: InputDecoration(labelText: label, border: InputBorder.none),
        onSaved: (v) => label == 'Change Song Title'
            ? themeNotifier.setTitle(v, widget.index)
            : themeNotifier.setArtist(v, widget.index),
      ),
    );
  }

  //Setting everything up
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setupVisualResources();
    getSongDetails();
  }

  //Setting visual resources
  double deviceHeight;
  Color light, dark;
  setupVisualResources() {
    deviceHeight = MediaQuery.of(context).size.height;
    light = Theme.of(context).primaryColorLight;
    dark = Theme.of(context).primaryColorDark;
  }

  //Retrieving local song details
  ThemeNotifier themeNotifier;
  AudioFunctions _audioFunctions = new AudioFunctions();
  void getSongDetails() async {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _audioFunctions = themeNotifier.getAudioFunctions();
  }
}
