import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Color(0xff196EB0),
  primaryColorDark: Color(0xffFF7551),
  primaryColorLight: Colors.amber,
  cardColor: Color(0xffE3F4FC),
  hintColor: Colors.black,
  primaryTextTheme: TextTheme(
    bodySmall: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.grey),
    titleMedium: TextStyle(color: Color(0xffFF7551)),
  ),
  dividerColor: Colors.grey,
  secondaryHeaderColor: Color(0xffF7F8F9),
  disabledColor: Color(0xffEFFAFF),
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xff0E1621),
  primaryColor: Color(0xff3B82F6),
  primaryColorDark: Color(0xffD4A017),
  hintColor: Colors.white,
  primaryColorLight: Color(0xFFEAB308),
  primaryTextTheme: TextTheme(
    bodySmall: TextStyle(color: Color(0xffE5E7EB)),
    bodyMedium: TextStyle(color: Color(0xff9CA3AF)),
    titleMedium: TextStyle(color: Color(0xffC2412D)),
  ),
  cardColor: Color(0xFF123447),
  secondaryHeaderColor: Color(0xff111827),
  dividerColor: Color(0xff9CA3AF),
  disabledColor: Color(0xFF0A2433),
);
