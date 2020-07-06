import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  //Swatch
  primarySwatch: MaterialColor(4289841361, {
    50: Color(0xffeff4f6),
    100: Color(0xffdfe8ec),
    200: Color(0xffbfd2d9),
    300: Color(0xff9fbbc6),
    400: Color(0xff7fa5b3),
    500: Color(0xff5f8ea0),
    600: Color(0xff4c7280),
    700: Color(0xff395560),
    800: Color(0xff263940),
    900: Color(0xff131c20)
  }),

  //primary colors
  primaryColor: Color(0xffb1c8d1),
  primaryColorLight: Color(0xffe3ecef),
  primaryColorDark: Color(0xffb1c8d1),

  //Default Bg
  backgroundColor: const Color(0xffb1c8d1),
  scaffoldBackgroundColor: Color(0xffb1c8d1),

  //Accent
  accentColor: Colors.black,

  //Button THeme
  buttonTheme: ButtonThemeData(
    shape: CircleBorder(),
    minWidth: 48,
    height: 48,
  ),

  //Default Font
  fontFamily: 'WorkSans',

  //TextThemes
  textTheme: TextTheme(
    headline1: TextStyle(
        fontFamily: 'WorkSans',
        letterSpacing: 1.5,
        fontSize: 28,
        color: Color(0xff494949),
        fontWeight: FontWeight.w900),
    headline2: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 14,
        letterSpacing: 1,
        color: Color(0xff494949),
        fontWeight: FontWeight.w800),
    headline3: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 28,
        color: Colors.white,
        fontWeight: FontWeight.w800),
    headline4: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600),
    headline5: TextStyle(
      fontFamily: 'WorkSans',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xff494949),
    ),
    headline6: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 20,
        color: Color(0xff494949),
        fontWeight: FontWeight.w600),
    caption: TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.w600,
      color: Color(0xff494949),
    ),
  ),

  //sliderTheme
  sliderTheme: SliderThemeData(
    activeTrackColor: Color(0xffe3ecef),
    inactiveTrackColor: Color(0xffb1c8d1),
    trackShape: RoundedRectSliderTrackShape(),
    trackHeight: 10,
    thumbColor: Color(0xffe3ecef),
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
    overlayColor: Color(0xffe3ecef).withAlpha(32),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
  ),

  //IconTHeme
  iconTheme: IconThemeData(color: Colors.white),

  //secondaryColor
  secondaryHeaderColor: Color(0xff354c54),

  //card color
  cardColor: Colors.black38,

  //dividerTheme
  dividerTheme: DividerThemeData(
      color: Colors.black38, thickness: 5, indent: 10, endIndent: 10),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  //Swatch
  primarySwatch: MaterialColor(4281349434, {
    50: Color(0xfff1f2f3),
    100: Color(0xffe3e6e8),
    200: Color(0xffc7ccd1),
    300: Color(0xffabb3ba),
    400: Color(0xff8f99a3),
    500: Color(0xff73808c),
    600: Color(0xff5c6670),
    700: Color(0xff454d54),
    800: Color(0xff3A3A3A),
    900: Color(0xff18191D)
  }),

  //Primary colors
  primaryColor: Color(0xff31363B),
  primaryColorLight: Color(0xff505050),
  primaryColorDark: Color(0xff252525),

  //Default Bg
  backgroundColor: const Color(0xff31363B),
  scaffoldBackgroundColor: Color(0xff31363B),

  //Accent
  accentColor: Colors.white,

  //Default font
  fontFamily: 'WorkSans',

  //Button theme
  buttonTheme: ButtonThemeData(
    shape: CircleBorder(),
    buttonColor: Color(0xff17191c),
    minWidth: 48,
    height: 48,
  ),

  //textTheme
  textTheme: TextTheme(
    headline1: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 28,
        letterSpacing: 1.5,
        color: Color(0xffe3ecef),
        fontWeight: FontWeight.w900),
    headline2: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 14,
        letterSpacing: 1,
        color: Color(0xffe3ecef),
        fontWeight: FontWeight.w800),
    headline3: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 28,
        color: Colors.white,
        fontWeight: FontWeight.w900),
    headline4: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600),
    headline5: TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: Color(0xffe3ecef),
    ),
    headline6: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600),
    caption: TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.w600,
      color: Color(0xffe3ecef),
    ),
  ),
  textSelectionColor: Colors.white54,

  //Slider Theme
  sliderTheme: SliderThemeData(
    activeTrackColor: Color(0xff494949),
    inactiveTrackColor: Color(0xff080b0f),
    trackShape: RoundedRectSliderTrackShape(),
    trackHeight: 10,
    thumbColor: Color(0xff494949),
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
    overlayColor: Color(0xff494949).withAlpha(32),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
  ),

  //icon theme
  iconTheme: IconThemeData(color: Colors.white),

  //secondary color
  secondaryHeaderColor: Color(0xff232323),

  //card color
  cardColor: Colors.white54,

  //divider theme
  dividerTheme: DividerThemeData(
      color: Colors.white54, thickness: 5, indent: 10, endIndent: 10),

  //textfield theme
  inputDecorationTheme: InputDecorationTheme(
      errorStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
);
