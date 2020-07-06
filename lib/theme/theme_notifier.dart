import 'package:flutter/material.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeNotifier(this._themeData);

  //For Theme
  ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }

  //For Audio FUnctions
  AudioFunctions _audioFunctions = AudioFunctions();
  AudioFunctions getAudioFunctions() => _audioFunctions;

  setAudioFunctions(AudioFunctions obj) {
    _audioFunctions = obj;
    notifyListeners();
  }

  //For Song Index
  int _songIndex = -1;
  Future<int> getSongIndex() async {
    if (_songIndex == -1) {
      return await SavePreference.getInt('songIndex') ?? 0;
    } else {
      return _songIndex;
    }
  }

  setSongIndex(int i) {
    _songIndex = i;
    SavePreference.saveInt('songIndex', i);
    notifyListeners();
  }

  //For AlbumArt
  String getAlbumArt(int i) =>
      _audioFunctions.songs[i].albumArtwork ?? 'Default';

  void setArt(String path, int index) =>
      _audioFunctions.songs[index].setAlbumArt(path);

  //For Song Title
  String getAlbumTitle(int i) => _audioFunctions.songs[i].title ?? 'Default';

  void setTitle(String title, int index) =>
      _audioFunctions.songs[index].setAlbumTitle(title);

  //For Song Artist
  String getAlbumArtist(int i) => _audioFunctions.songs[i].artist ?? 'Default';

  void setArtist(String artist, int index) =>
      _audioFunctions.songs[index].setAlbumArtist(artist);
}
