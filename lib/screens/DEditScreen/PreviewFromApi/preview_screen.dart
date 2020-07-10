import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:provider/provider.dart';

class PreviewScreen extends StatefulWidget {
  static String id = 'PreviewScreen';
  const PreviewScreen({Key key, @required this.data, @required this.limit});

  final Map<int, Map<String, dynamic>> data;
  final int limit;

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  List<bool> isSelected = [];
  @override
  void initState() {
    super.initState();
    isSelected = List<bool>.generate(widget.limit, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColorDark
                ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Select A Card',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text('There is more ->')
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: widget.data.entries
                        .map((e) => buildPreviews(e.key, e.value, context))
                        .toList(),
                  ),
                ),
                RaisedButton(
                  onPressed: () => onSearchClick(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Text('SELECT'),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: () {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Text('CANCEL'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center buildPreviews(
      int index, Map<String, dynamic> value, BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            for (int i = 0; i < widget.limit; i++) {
              isSelected[i] = i == index ? true : false;
            }
          });
        },
        child: Container(
          margin: EdgeInsets.all(40),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColorDark
                ]),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: isSelected[index] ? kRaisedButtonShadow.boxShadow : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.15),
                decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(value['art'])
//                        image: AssetImage('assets/thumbnail.jpg')
                        )),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                value['title'],
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(value['artist']),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSearchClick() async {
    //Finding Selected Card
    int _currentIndex = -1;
    for (int i = 0; i < 5; i++) {
      if (isSelected[i]) _currentIndex = i;
    }

    //Checking if any card is selected
    if (_currentIndex == -1) {
      FlutterToast.showToast(
        msg: 'Select a card to continue',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    //Retrieving API data of selected card
    final Map<String, dynamic> _selectedMap = widget.data[_currentIndex];

    //Downloading art
    String _path;
    try {
      final _imageId = await ImageDownloader.downloadImage(_selectedMap['art']);
      _path = await ImageDownloader.findPath(_imageId);
    } catch (e) {
      print(e.toString());
      FlutterToast.showToast(
        msg: 'Error occurred '
            'while downloading art. Try Again Later',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    //Setting up Provider
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final int _songIndex = await themeNotifier.getSongIndex();

    //Saving data to Provider
    themeNotifier.setArt(_path, _songIndex);
    themeNotifier.setTitle(_selectedMap['title'], _songIndex);
    themeNotifier.setArtist(_selectedMap['artist'], _songIndex);

    //Popping back to edit screen
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }
}
