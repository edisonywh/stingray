import 'package:flutter/material.dart';

ThemeData trueBlackTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.white,
  primaryColor: Color(0xFFFFC98A),
  accentColor: Color(0xFFFFC98A),
  cardTheme: ThemeData().cardTheme.copyWith(
        color: Color(0xFF1C1C1C),
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Color(0xFF1F1F1F),
  primaryColor: Color(0xFFFFC98A),
  accentColor: Color(0xFFFFC98A),
  cardTheme: ThemeData().cardTheme.copyWith(
        color: Color(0xFF1C1C1C),
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
