import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final Map<IconData, String> menuItems = {
  FontAwesomeIcons.slidersH: 'EQUALIZER',
  FontAwesomeIcons.laptop: 'DEVICES',
  FontAwesomeIcons.trash: 'DELETE CACHE',
  FontAwesomeIcons.info: 'ABOUT',
  FontAwesomeIcons.wrench: 'SETTINGS',
};

final BoxDecoration raisedButtonShadow = BoxDecoration(
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
