import 'package:flutter/material.dart';
import 'package:six_cash/util/color_resources.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: Color(0xFF689da7),
  secondaryHeaderColor: Color(0xFFaaa818),
  brightness: Brightness.dark,
  textTheme: TextTheme(
    titleLarge: TextStyle(color:Color(0xFF8dbac3)),
    titleSmall: TextStyle(color: Color(0xFF25282D)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: ColorResources.blackColor,selectedItemColor: ColorResources.themeDarkBackgroundColor),
);
