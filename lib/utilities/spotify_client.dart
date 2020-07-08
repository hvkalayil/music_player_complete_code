import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class SpotifyOAuth2Client extends OAuth2Client {
  SpotifyOAuth2Client(
      {@required String redirectUri, @required String customUriScheme})
      : super(
            authorizeUrl:
                'https://accounts.spotify.com/authorize', //Your service's authorization url
            tokenUrl:
                'https://accounts.spotify.com/api/token', //Your service access token url
            redirectUri: redirectUri,
            customUriScheme: customUriScheme) {
    this.accessTokenRequestHeaders = {'Accept': 'application/json'};
  }
}

//Error codes
//204 - No Content
//404 - Not Found
//429 - Too Many requests

class SpotifyAPI {
  static const limit = 5;
  static Future<Map<int, Map<String, dynamic>>> getData(String query) async {
    //Getting secret key
    final _keys = await kGetKeys();

    //Getting token
    SpotifyOAuth2Client client = SpotifyOAuth2Client(
        customUriScheme: 'com.hoseakalayil.musicplayer',
        redirectUri: 'com.hoseakalayil.musicplayer:/oauth2redirect');
    OAuth2Helper helper = OAuth2Helper(client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE, clientId: _keys[0]);

    //Searching
    Uri requestUrl = Uri.parse('https://api.spotify.com/v1/search?'
        'q=$query'
        '&type=track');
    http.Response res = await helper.get(requestUrl.toString());

    final responseCode = res.statusCode;
    Map<int, Map<String, dynamic>> responseData = {};

    //Success
    if (responseCode == 200) {
      final body = jsonDecode(res.body);
      for (int i = 0; i < 5; i++) {
        //Break if there is less than 5
        try {
          responseData.addAll({
            i: {
              'code': responseCode,
              'art': body['tracks']['items'][i]['album']['images'][0]['url'],
              'title': body['tracks']['items'][i]['album']['name'],
              'artist': body['tracks']['items'][i]['artists'][0]['name']
            }
          });
        } catch (e) {
          responseData.addAll({
            0: {'code': 204}
          });
          break;
        }
      }
      print(responseData);
    }

    //Failure
    else {
      responseData.addAll({
        0: {
          'code': responseCode,
        }
      });
    }

    //Sending response
    return responseData;
  }
}
