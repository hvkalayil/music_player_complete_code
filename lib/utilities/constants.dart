import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final Map<IconData, String> kMenuItems = {
  FontAwesomeIcons.slidersH: 'EQUALIZER',
  FontAwesomeIcons.laptop: 'DEVICES',
  FontAwesomeIcons.trash: 'DELETE CACHE',
  FontAwesomeIcons.info: 'ABOUT',
  FontAwesomeIcons.wrench: 'SETTINGS',
};

final BoxDecoration kRaisedButtonShadow = BoxDecoration(
  shape: BoxShape.circle,
  boxShadow: [
    BoxShadow(
        color: Colors.white.withAlpha(100),
        blurRadius: 16,
        offset: Offset(-9, -9)),
    BoxShadow(
        color: Colors.black.withAlpha(100),
        blurRadius: 16,
        offset: Offset(9, 9))
  ],
);

Future<List<String>> kGetKeys() async {
  final String keys = await rootBundle.loadString('secrets.json');
  List<String> _keys = [];
  _keys.add(keys.split('"')[3]);
  _keys.add(keys.split('"')[7]);
  return _keys;
}
