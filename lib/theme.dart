import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final StateProvider themeProvider = StateProvider((ref) {
  return darkTheme;
});

ThemeData trueBlackTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.white,
  primaryColor: Color(0xFFFFC98A),
  accentColor: Color(0xFFFFC98A),
  indicatorColor: Color(0xFFFFC98A),
  toggleableActiveColor: Color(0xFFFFC98A),
  cardTheme: ThemeData().cardTheme.copyWith(
        color: Color(0xFF1C1C1C),
      ),
  appBarTheme: ThemeData().appBarTheme.copyWith(
        color: Colors.black,
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Color(0xFF1F1F1F),
  primaryColor: Color(0xFFFFC98A),
  accentColor: Color(0xFFFFC98A),
  indicatorColor: Color(0xFFFFC98A),
  toggleableActiveColor: Color(0xFFFFC98A),
  cardTheme: ThemeData().cardTheme.copyWith(
        color: Color(0xFF1C1C1C),
      ),
  appBarTheme: ThemeData().appBarTheme.copyWith(
        color: Color(0xFF1F1F1F),
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: Color(0xFFF99602),
  accentColor: Color(0xFFF99602),
  indicatorColor: Color(0xFFF99602),
  toggleableActiveColor: Color(0xFFF99602),
  tabBarTheme: ThemeData().tabBarTheme.copyWith(
        unselectedLabelColor: Colors.grey,
        labelColor: Color(0xFFF99602),
      ),
  appBarTheme: ThemeData().appBarTheme.copyWith(
        color: Colors.white,
        iconTheme: ThemeData().iconTheme.copyWith(color: Colors.black),
      ),
  textTheme: ThemeData().textTheme.copyWith(
        caption: ThemeData().textTheme.caption.copyWith(
              color: Colors.grey,
            ),
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
