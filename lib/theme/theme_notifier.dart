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

  void setArt(String path, int index) {
    _audioFunctions.songs[index].setAlbumArt(path);
    notifyListeners();
  }

  //For Song Title
  String title = '';
  void setNotifierTitle(String value) {
    title = value;
    notifyListeners();
  }

  String getAlbumTitle(int i) => _audioFunctions.songs[i].title ?? 'Default';

  void setTitle(String title, int index) {
    _audioFunctions.songs[index].setAlbumTitle(title);
    notifyListeners();
  }

  //For Song Artist
  String artist = '';
  void setNotifierArtist(String value) {
    artist = value;
    notifyListeners();
  }

  String getAlbumArtist(int i) => _audioFunctions.songs[i].artist ?? 'Default';

  void setArtist(String artist, int index) {
    _audioFunctions.songs[index].setAlbumArtist(artist);
    notifyListeners();
  }

  //For searchBar
  bool isLocal = true;
  void setIsLocal(bool value) {
    isLocal = value;
    notifyListeners();
  }

  //For queried list indices for local songs
  List<int> listOfIndices = [];
  void setListOfIndices(List<int> value) {
    listOfIndices = value;
    notifyListeners();
  }

  //For queried list indices for api songs
  Map<int, Map> apiData = {};
  void setApiData(Map<int, Map> value) {
    apiData = value;
    notifyListeners();
  }

  int apiSelectedIndex = 0;
  void setApiSelectedIndex(int value) {
    apiSelectedIndex = value;
    notifyListeners();
  }

  //Check if listening to input
  bool isNotListening = true;
  void setIsNotListening(bool value) {
    isNotListening = value;
    notifyListeners();
  }

  //Check if online song
  bool isOnlineSong = false;
  void setIsOnlineSong(bool value) {
    isOnlineSong = value;
    notifyListeners();
  }

  String currentPlayList = '';
  void setCurrentPlayList(String value) {
    currentPlayList = value;
    notifyListeners();
  }

  List<String> listOfPlaysLists = ['Favourites'];
  void setListOfPlayLists(List<String> value) {
    listOfPlaysLists = value;
    notifyListeners();
  }

  bool toggle = true;
  void setToggle(bool value) {
    toggle = value;
    notifyListeners();
  }

  bool playTheList = false;
  void setPlayTheList(bool value) {
    playTheList = value;
    notifyListeners();
  }

  //For selecting songs
  bool selectionMode = false;
  void setSelectionMode(bool value) {
    selectionMode = value;
    notifyListeners();
  }

  List<int> selectedIndices = [];
  void setSelectedIndices(List<int> value) {
    selectedIndices = value;
    notifyListeners();
  }

  //Default Download Path
  String defaultPath = '';
  Future<String> getDefaultPath() async {
    return await SavePreference.getString('defaultPath') ?? '';
  }

  void setDefaultPath(String value) {
    SavePreference.saveString('defaultPath', value);
    defaultPath = value;
    notifyListeners();
  }

  //Downloaded songs
  Map<int, Map> downloadedSongs = {};
  void setDownloadedSongs(Map<int, Map> value) {
    downloadedSongs = value;
    notifyListeners();
  }

  //Turning off
  String timerSetFor = '';
  void setTimerSetFor(String value) {
    timerSetFor = value;
    notifyListeners();
  }

  //Batch Remove songs
  bool isRemoveFromPlaylist = false;
  void setIsRemoveFromPlaylist(bool value) {
    isRemoveFromPlaylist = value;
    notifyListeners();
  }

  bool hideList = true;
  Future<bool> getHideList() async {
    final bool v = await SavePreference.getBool('hideListView') ?? true;
    return v;
  }

  void setHideList(bool value) {
    hideList = value;
    SavePreference.saveBool('hideListView', value);
    notifyListeners();
  }
}
