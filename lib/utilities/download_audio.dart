import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadAudio {
  //YTExplode Object
  YoutubeExplode yt;
  DownloadAudio() {
    yt = YoutubeExplode();
  }

  //Search Function
  Future<Map<int, Map>> search(String query) async {
    Map<int, Map> data = {};

    //Searching
    final SearchQuery search = await yt.search.queryFromPage(query);

    //Getting content one by one
    int i = 0;
    final List response = search.content;
    response.forEach((element) async {
      data.addAll({
        i: {
          'manifest': element.videoId,
          'art': 'assets/thumbnail.jpg',
          'title': element.videoTitle,
          'artist': element.videoAuthor,
          'url': '404',
          'href': '404',
        }
      });
      i++;
    });
    return data;
  }

  //Get Art and Link
  Future<Map> getArtAndLink(Map data) async {
    final manifest = data['manifest'];
    //Getting the stream info
    final thumbnail = await yt.videos.get(manifest);
    final audioStream = await yt.videos.streamsClient.getManifest(manifest);

    data['art'] = thumbnail.thumbnails.highResUrl;
    data['url'] = audioStream.audioOnly.withHighestBitrate().url.toString();
    data['href'] = thumbnail.url;
    return data;
  }

  //Download Function
  Future<void> download(
      Map data, String path, int length, ThemeNotifier themeNotifier) async {
    //Getting the stream info
    final StreamManifest streamManifest =
        await yt.videos.streamsClient.getManifest(data['manifest']);
    final AudioOnlyStreamInfo streamInfo =
        streamManifest.audio.withHighestBitrate();

    //Downloading to file if exist
    if (streamInfo != null) {
      //Getting the actual stream
      final Stream<List<int>> stream = yt.videos.streamsClient.get(streamInfo);
      //Writing to File
      File file;
      final status = await Permission.storage.status;
      if (status.isGranted) {
        try {
          final String fileFormat = streamInfo.audioCodec.split('.')[0];
          final String fileName = data['title'];
          file = File(path + '/$fileName.$fileFormat');

          var fileStream = file.openWrite();
          await stream.pipe(fileStream);

          //Flushing Stream
          await fileStream.flush();
          await fileStream.close();

          //Downloading thumbnail

          var thumbnailDownloadTask =
              await ImageDownloader.downloadImage(data['art']);
          final String thumbnailPath = thumbnailDownloadTask != null
              ? await ImageDownloader.findPath(thumbnailDownloadTask)
              : 'assets/thumbnail.jpg';
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

          tempIndicesInt.add(length + tempIndicesInt.length);
          tempTitles.add(data['title']);
          tempArtist.add(data['artist']);
          tempArt.add(data['art']);
          tempPath.add(thumbnailPath);

          tempIndicesString = [];
          tempIndicesInt
              .forEach((element) => tempIndicesString.add(element.toString()));

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

          themeNotifier.setDownloadedSongs(downloadedSongs);
          SavePreference.saveStringList('downloadedIndices', tempIndicesString);
          SavePreference.saveStringList('downloadedTitle', tempTitles);
          SavePreference.saveStringList('downloadedArtist', tempArtist);
          SavePreference.saveStringList('downloadedArt', tempArt);
          SavePreference.saveStringList('downloadedPath', tempPath);

          FlutterToast.showToast(msg: 'Download finished');
        } catch (e) {
          print(status.toString());
          print(e.toString());
          FlutterToast.showToast(
              msg: 'There has been an error with the path. Try another path');
        }
      } else {
        final PermissionStatus states = await Permission.storage.request();
        print(states);
        FlutterToast.showToast(msg: 'Try downloading now');
      }
    }
  }
}
