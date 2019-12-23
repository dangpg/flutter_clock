import 'package:flutter/material.dart';

class ClockTheme {
  static ThemeData of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
  }

  static final ThemeData _lightTheme = ThemeData(
    backgroundColor: Color(0xFFFAFAFA),
    // Color of sliders
    cursorColor: Color(0xFFDB4437),
    // Color of body of cards
    cardColor: Colors.white,
    // Border color
    dividerColor: Colors.grey,
    // BoxShadow color #1
    canvasColor: Color(0xFFF4F4F4),
    //BoxShadow color #2
    highlightColor: Colors.grey[400],
    // Ticks
    accentColor: Colors.grey[800],
    textTheme: TextTheme(
      title: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      subtitle: TextStyle(color: Colors.grey[800]),
      headline: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      subhead: TextStyle(color: Colors.grey[800]),
      body1: TextStyle(color: Color(0xFF0F9D58), fontWeight: FontWeight.bold), // Weekday Widget
      body2: TextStyle(color: Color(0xFF4285F4), fontWeight: FontWeight.bold), // AMPM Widget
      display1: TextStyle(color: Color(0xFF4285F4)),
      display2: TextStyle(color: Color(0xFFDB4437)),
      display3: TextStyle(color: Color(0xFFF4B400)),
      display4: TextStyle(color: Color(0xFF0F9D58)),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    backgroundColor: Color(0xFF141414),
    // Color of sliders
    cursorColor: Color(0xFFDB4437),
    // Color of body of cards
    cardColor: Colors.black,
    // Border color
    dividerColor: Colors.black,
    // BoxShadow color #1
    canvasColor: Colors.black,
    //BoxShadow color #2
    highlightColor: Color(0xFF202020),
    // Ticks
    accentColor: Colors.white,
    textTheme: TextTheme(
      title: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      subtitle: TextStyle(color: Colors.white, fontSize: 10.0),
      headline: TextStyle(color: Colors.white),
      subhead: TextStyle(color: Colors.white),
      body1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Weekday Widget
      body2: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // AMPM Widget
      display1: TextStyle(color: Colors.white),
      display2: TextStyle(color: Colors.white),
      display3: TextStyle(color: Colors.white),
      display4: TextStyle(color: Colors.white),
    ),
  );
}
