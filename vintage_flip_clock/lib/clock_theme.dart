import 'package:flutter/material.dart';

class ClockTheme {
  static ThemeData of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
  }

  static final ThemeData _lightTheme = ThemeData(
    backgroundColor: Colors.white,
    // Color of sliders
    cursorColor: Colors.red,
    // Color of body of cards
    cardColor: Colors.white,
    // Border color
    dividerColor: Colors.grey,
    // BoxShadow color #1
    canvasColor: Colors.grey,
    //BoxShadow color #2
    highlightColor: Color(0xFF606060),
    // General text color
    accentColor: Colors.black,
    textTheme: TextTheme(
      title: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      subtitle: TextStyle(color: Colors.black, fontSize: 10.0),
      headline: TextStyle(color: Colors.black),
      subhead: TextStyle(color: Colors.black),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    backgroundColor: Color(0xFF141414),
    // Color of sliders
    cursorColor: Colors.red,
    // Color of body of cards
    cardColor: Colors.black,
    // Border color
    dividerColor: Colors.black,
    // BoxShadow color #1
    canvasColor: Colors.black,
    //BoxShadow color #2
    highlightColor: Color(0xFF202020),
    // General text color
    accentColor: Colors.white,
    textTheme: TextTheme(
      title: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      subtitle: TextStyle(color: Colors.white, fontSize: 10.0),
      headline: TextStyle(color: Colors.white),
      subhead: TextStyle(color: Colors.white),
    ),
  );
}
