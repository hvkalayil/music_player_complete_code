import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/BHomeScreen/thumbnail.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'PreviewFromApi/online_art.dart';
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
  String art, title, artist;
  ThemeNotifier themeNotifier;

  @override
  void initState() {
    super.initState();
    savingOriginalDetails();
  }

  //Saving to repopulate details onCancel
  void savingOriginalDetails() {
    //Retrieving
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    art = themeNotifier.getAlbumArt(widget.index);
    title = themeNotifier.getAlbumTitle(widget.index);
    artist = themeNotifier.getAlbumArtist(widget.index);

    //Saving
    SavePreference.saveString('albumArt', art);
    SavePreference.saveString('albumTitle', title);
    SavePreference.saveString('albumArtist', artist);
  }

  @override
  Widget build(BuildContext context) {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
            decoration: kRaisedButtonShadow,
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
            decoration: kRaisedButtonShadow,
            child: RaisedButton(
              onPressed: () async {
                final _formState = _formKey.currentState;
                if (_formState.validate()) {
                  _formState.save();

                  //Retrieving all edits
                  List<String> editedIndices =
                      await SavePreference.getStringList('editedIndices') ?? [];
                  List<String> editedArts =
                      await SavePreference.getStringList('editedArts') ?? [];
                  List<String> editedTitles =
                      await SavePreference.getStringList('editedTitles') ?? [];
                  List<String> editedArtists =
                      await SavePreference.getStringList('editedArtists') ?? [];

                  //Adding new edits
                  final String i = widget.index.toString();
                  final int index = editedIndices.indexOf(i);
                  if (index != -1) {
                    editedIndices[index] = i;
                    editedArts[index] = themeNotifier.getAlbumArt(widget.index);
                    editedTitles[index] =
                        themeNotifier.getAlbumTitle(widget.index);
                    editedArtists[index] =
                        themeNotifier.getAlbumArtist(widget.index);
                  } else {
                    editedIndices.add(i);
                    editedArts.add(themeNotifier.getAlbumArt(widget.index));
                    editedTitles.add(themeNotifier.getAlbumTitle(widget.index));
                    editedArtists
                        .add(themeNotifier.getAlbumArtist(widget.index));
                  }

                  //Saving new edits
                  SavePreference.saveStringList('editedIndices', editedIndices);
                  SavePreference.saveStringList('editedArts', editedArts);
                  SavePreference.saveStringList('editedTitles', editedTitles);
                  SavePreference.saveStringList('editedArtists', editedArtists);

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
  }

  //Setting visual resources
  double deviceHeight;
  Color light, dark;
  setupVisualResources() {
    deviceHeight = MediaQuery.of(context).size.height;
    light = Theme.of(context).primaryColorLight;
    dark = Theme.of(context).primaryColorDark;
  }
}
