import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';

//SongInfo({
//_data: /storage/6264-3733/Music/Ethu Kari Raavilum - Bangalore Days (WapMallu.CoM).mp3,
//album_artwork: /storage/emulated/0/Android/data/com.android.providers.media/albumthumbs/1572310783681,
//_display_name: Ethu Kari Raavilum - Bangalore Days (WapMallu.CoM).mp3,
//artist: | WapMallu.CoM |,
//year: 2014, album: Bangalore Days | WapMallu.CoM,
//composer: null, is_music: true, is_ringtone: false,
//title: | WapMallu.CoM | - Ethu Kari Raavilum - Bangalore Days,
//    artist_id: 31, is_podcast: false,

//    duration: 327192,

//_size: 5272347, is_alarm: false, bookmark: null, album_id: 26,
//is_notification: false, _id: 62434, track: 0})

class AudioFunctions {
  FlutterAudioQuery audioQuery;
  AudioPlayer audioPlayer;
  List<SongInfo> songs;
  Map<String, String> localSongs;
  int len;

  AudioFunctions() {
    this.audioQuery = FlutterAudioQuery();
    this.audioPlayer = AudioPlayer();
    this.songs = [];
    this.len = 0;
  }

  getLocalSongs() async {
    this.songs = await audioQuery.getSongs();
    this.len = this.songs.length;

    //Updating list if changes exist
    final List<String> editedIndices =
        await SavePreference.getStringList('editedIndices') ?? [];
    if (editedIndices != []) {
      //Retrieving edits
      final List<String> editedArts =
          await SavePreference.getStringList('editedArts') ?? [];
      final List<String> editedTitles =
          await SavePreference.getStringList('editedTitles') ?? [];
      final List<String> editedArtists =
          await SavePreference.getStringList('editedArtists') ?? [];

      //Saving edits
      int i = 0;
      editedIndices.forEach((element) {
        final int index = int.parse(element);
        this.songs[index].setAlbumArt(editedArts[i]);
        this.songs[index].setAlbumTitle(editedTitles[i]);
        this.songs[index].setAlbumArtist(editedArtists[i]);
        i++;
      });
    }
  }

  void playLocalSong(String path) {
    try {
      audioPlayer.play(
        path,
        isLocal: true,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void playOnlineSong(String url) {
    try {
      audioPlayer.play(
        url,
        isLocal: false,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void pauseLocalSong() {
    audioPlayer.pause();
  }

  Stream<Duration> getLength() {
    return audioPlayer.onDurationChanged;
  }

  Stream<Duration> getPosition() {
    return audioPlayer.onAudioPositionChanged;
  }

  Future<int> changeSlider(Duration d) {
    return audioPlayer.seek(d);
  }

  Stream<AudioPlayerState> getState() {
    return audioPlayer.onPlayerStateChanged;
  }

  Future<List<SongInfo>> searchLocalSong(String query) {
    return audioQuery.searchSongs(query: query);
  }
}
