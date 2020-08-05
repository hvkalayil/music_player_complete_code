import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:provider/provider.dart';

class PlayListView extends StatefulWidget {
  @override
  _PlayListViewState createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  bool toggle = true;
  String selectedName = 'Favourites';
  int selected = 0;
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
      padding: EdgeInsets.all(10),
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
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    toggle = !toggle;
                  });
                  themeNotifier.setToggle(toggle);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      themeNotifier.currentPlayList,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Icon(toggle ? Icons.arrow_drop_down_circle : Icons.clear,
                        color: Theme.of(context).accentColor),
                  ],
                ),
              ),

              //Create New PlayList
              Container(
                decoration: kRaisedButtonShadow,
                child: RaisedButton(
                  onPressed: () {
                    final List<String> theList = themeNotifier.listOfPlaysLists;
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Column(
                                children: [
                                  Text(
                                    'Create New PlayList',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                  Divider()
                                ],
                              ),
                              content: Form(
                                key: _key,
                                child: TextFormField(
                                  // ignore: missing_return
                                  validator: (v) {
                                    if (v.isEmpty) {
                                      return 'Enter Playllist Name';
                                    } else if (theList.contains(v)) {
                                      return 'This PlayList already exists.';
                                    }
                                  },
                                  textInputAction: TextInputAction.done,

                                  //DECORATION
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(FontAwesomeIcons.plus),
                                      labelText: 'Create New PlayList',
                                      border: InputBorder.none),

                                  //FINISH
                                  onSaved: (input) async {
                                    theList.add(input);
                                    themeNotifier.setListOfPlayLists(theList);
                                    themeNotifier.setCurrentPlayList(names[0]);
                                    final Map<String, List<int>> data =
                                        await getPlayList();
                                    data.addAll({input: <int>[]});
                                    savePlayLists(data);
                                  },
                                ),
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('CANCEL')),
                                FlatButton(
                                    onPressed: () async {
                                      final FormState _state =
                                          _key.currentState;
                                      if (_state.validate()) {
                                        _state.save();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('DONE'))
                              ],
                            ));
                  },
                  child: Icon(FontAwesomeIcons.plus),
                ),
              )
            ],
          ),
          toggle ? SizedBox() : Text('Double Tap on a playlist to play'),
          Container(
            height: toggle
                ? MediaQuery.of(context).size.height * 0
                : MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: names.length,
              itemBuilder: (context, index) => makePlayLists(index),
            ),
          )
        ],
      ),
    );
  }

  //ListItem Builder
  makePlayLists(int index) {
    try {
      return GestureDetector(
        onDoubleTap: () async {
          if (indices[index].isEmpty) {
            FlutterToast.showToast(
                msg: 'Oops! Add some songs to your playlist first',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM);
          } else {
            selectList(index);
            themeNotifier.setSongIndex(indices[index][0]);
            themeNotifier.setListOfIndices(indices[index]);
            themeNotifier.setCurrentPlayList(names[index]);
            themeNotifier.setPlayTheList(true);
            await themeNotifier.getAudioFunctions().audioPlayer.release();
            Navigator.pop(context);
          }
        },
        onTap: () {
          selectList(index);
          themeNotifier.setListOfIndices(indices[index]);
          themeNotifier.setCurrentPlayList(names[index]);
        },
        child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            margin: EdgeInsets.fromLTRB(20, 20, 10, 20),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                boxShadow: toggleSelection[index]
                    ? [
                        BoxShadow(
                            color: Colors.white12,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(-5, -8)),
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(5, 8))
                      ]
                    : [],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: FocusedMenuHolder(
              menuItems: [
                FocusedMenuItem(
                    title: Text('Delete Playlist'),
                    onPressed: () async {
                      try {
                        if (names[index] == 'Favourites') {
                          FlutterToast.showToast(
                              msg: 'Sorry! You cannot delete this playlist.');
                        } else {
                          Map<String, List<int>> data = await getPlayList();
                          data.remove(names[index]);
                          themeNotifier.setCurrentPlayList(names[0]);
                          names.removeAt(index);
                          themeNotifier.setListOfPlayLists(names);
                          savePlayLists(data);
                          FlutterToast.showToast(msg: 'Successfully deleted');
                        }
                      } catch (e) {
                        FlutterToast.showToast(
                            msg:
                                'Sorry! There was an error while deleting playlist.');
                      }
                    })
              ],
              onPressed: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    child: Text(
                      names[index],
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  indices[index].isEmpty
                      ? Text('No songs added')
                      : Text('${indices[index].length} songs'),
                ],
              ),
            )),
      );
    } catch (e) {
      return SizedBox();
    }
  }

  void selectList(int index) {
    //SELECTION PROCESS
    List<bool> temp = [];
    for (int i = 0; i < toggleSelection.length; i++) {
      if (index == i)
        temp.add(true);
      else
        temp.add(false);
    }
    setState(() {
      toggleSelection = temp;
    });
  }

  ThemeNotifier themeNotifier;
  @override
  void initState() {
    super.initState();
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    getInitialData();
  }

  List<String> names = [];
  List<List<int>> indices = [];
  List<bool> toggleSelection = [];
  getInitialData() async {
    final Map<String, List<int>> data = await getPlayList();
    data.forEach((key, value) {
      names.add(key);
      indices.add(value);
    });
    themeNotifier.setListOfPlayLists(names);
    toggleSelection =
        List<bool>.generate(names.length, (index) => index == 0 ? true : false);
    themeNotifier.setCurrentPlayList(names[0]);
    themeNotifier.setListOfIndices(indices[0]);
  }
}
