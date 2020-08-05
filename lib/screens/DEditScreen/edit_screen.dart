import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/BHomeScreen/home_screen.dart';
import 'package:musicplayer/screens/BHomeScreen/thumbnail.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/google_ads.dart';
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
  @override
  void initState() {
    super.initState();
    //Setting ad
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );

    savingOriginalDetails();
  }

  //Saving to repopulate details onCancel
  ThemeNotifier themeNotifier;
  TextEditingController _titleController, _artistController;
  void savingOriginalDetails() {
    //Retrieving
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final String art = themeNotifier.getAlbumArt(widget.index);
    final String title = themeNotifier.getAlbumTitle(widget.index);
    final String artist = themeNotifier.getAlbumArtist(widget.index);
    _titleController = TextEditingController(text: title);
    _artistController = TextEditingController(text: artist);

    //Saving
    SavePreference.saveString('albumArt', art);
    SavePreference.saveString('albumTitle', title);
    SavePreference.saveString('albumArtist', artist);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                  editSongDetails('Change Song Title', _titleController),

                  //Change Song Author
                  editSongDetails('Change Song Artist', _artistController),

                  //Banner Ad
                  BannerAdPage()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Top Bar
  Container editTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: kRaisedButtonShadow,
            child: RaisedButton(
              onPressed: () => onCancelClick(),
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
              onPressed: () => onSaveClick(),
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

  //Part of topbar
  Future<void> onCancelClick() async {
    //Retrieving
    final String originalArt = await SavePreference.getString('albumArt');
    final String originalTitle = await SavePreference.getString('albumTitle');
    final String originalArtist = await SavePreference.getString('albumArtist');

    //Repopulating
    themeNotifier.setArt(originalArt, widget.index);
    themeNotifier.setArt(originalTitle, widget.index);
    themeNotifier.setArt(originalArtist, widget.index);

    Navigator.pop(context);
  }

  //Part of topbar
  Future<void> onSaveClick() async {
    Random r = Random();
    final bool show = r.nextBool();

    if (show) {
      _createInterstitalAd();
      _interstitialAd..show();
    }

    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();

      //Retrieving all previous edits
      List<String> editedIndices =
          await SavePreference.getStringList('editedIndices') ?? [];
      List<String> editedArts =
          await SavePreference.getStringList('editedArts') ?? [];
      List<String> editedTitles =
          await SavePreference.getStringList('editedTitles') ?? [];
      List<String> editedArtists =
          await SavePreference.getStringList('editedArtists') ?? [];

      //Adding current edits
      final String i = widget.index.toString();
      final int index = editedIndices.indexOf(i);
      if (index != -1) {
        editedIndices[index] = i;
        editedArts[index] = themeNotifier.getAlbumArt(widget.index);
        editedTitles[index] = themeNotifier.getAlbumTitle(widget.index);
        editedArtists[index] = themeNotifier.getAlbumArtist(widget.index);
      } else {
        editedIndices.add(i);
        editedArts.add(themeNotifier.getAlbumArt(widget.index));
        editedTitles.add(themeNotifier.getAlbumTitle(widget.index));
        editedArtists.add(themeNotifier.getAlbumArtist(widget.index));
      }

      //Saving new edits
      SavePreference.saveStringList('editedIndices', editedIndices);
      SavePreference.saveStringList('editedArts', editedArts);
      SavePreference.saveStringList('editedTitles', editedTitles);
      SavePreference.saveStringList('editedArtists', editedArtists);
    }
    if (!show) Navigator.pop(context);
  }

  //Edit titles
  Container editSongDetails(String label, TextEditingController _controller) {
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
        controller: _controller,
        // ignore: missing_return
        validator: (input) {
          if (input.isEmpty) return 'This field should not be empty';
        },
        style: Theme.of(context).textTheme.headline6,
        decoration: InputDecoration(labelText: label, border: InputBorder.none),
        onSaved: (v) => label == 'Change Song Title'
            ? themeNotifier.setTitle(v, widget.index)
            : themeNotifier.setArtist(v, widget.index),
      ),
    );
  }

  //Setting colors
  double deviceHeight;
  Color light, dark;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceHeight = MediaQuery.of(context).size.height;
    light = Theme.of(context).primaryColorLight;
    dark = Theme.of(context).primaryColorDark;
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
        Navigator.popUntil(
            context, (route) => route.settings.name == HomeScreen.id);
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
