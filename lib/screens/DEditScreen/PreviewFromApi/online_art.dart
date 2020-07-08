import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:musicplayer/screens/DEditScreen/PreviewFromApi/preview_screen.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:musicplayer/utilities/spotify_client.dart';
import 'package:provider/provider.dart';

class OnlineArt extends StatefulWidget {
  const OnlineArt({Key key, @required this.index}) : super(key: key);
  final int index;
  @override
  _OnlineArtState createState() => _OnlineArtState();
}

class _OnlineArtState extends State<OnlineArt> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: kRaisedButtonShadow,
          child: RaisedButton(
            onPressed: () => onSearchClick(context),
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Search',
          style: Theme.of(context).textTheme.headline2,
        )
      ],
    );
  }

  void onSearchClick(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    String _newName = themeNotifier.getAlbumTitle(widget.index);
    showDialog(
      context: context,
      barrierColor: Theme.of(context).primaryColorLight,
      builder: (_) => AlertDialog(
          backgroundColor: Theme.of(context).primaryColorLight,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          //TITLE
          title: Text('Enter Name of Song', textAlign: TextAlign.center),
          titlePadding: EdgeInsets.all(20),
          titleTextStyle: Theme.of(context).textTheme.headline1,

          //CONTENT
          content: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20),
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
                // ignore: missing_return
                validator: (input) {
                  if (input.isEmpty) return 'This field should not be empty';
                },
                initialValue: _newName,
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                    labelText: 'Song Title', border: InputBorder.none),
                onSaved: (v) => _newName = v,
              ),
            ),
          ), //ACTIONS
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: () async {
                final _formState = _formKey.currentState;
                if (_formState.validate()) {
                  _formState.save();

                  //Fetching API Data
                  final Map<int, Map<String, dynamic>> _apiData =
                      await SpotifyAPI.getData(_newName);

                  //Success
                  if (_apiData[0]['code'] == 200) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewScreen(
                                  data: _apiData,
                                )));
                  }

                  //Failure
                  else {
                    final String errorMsg = _apiData[0]['code'] == 429
                        ? 'Too many requests'
                        : _apiData[0]['code'] == 204
                            ? 'This title does not exist in the database'
                            : 'Some Error has occurred';
                    FlutterToast.showToast(
                      msg: errorMsg,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                }
              },
              child: Text('Search'),
            ),
          ]),
    );
  }
}
