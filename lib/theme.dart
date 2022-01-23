import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeManager, ThemeData>((ref) {
  return ThemeManager();
});

class ThemeManager extends StateNotifier<ThemeData> {
  ThemeManager() : super(darkTheme);

  Future setTheme(ThemeData theme) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('theme', themeName(theme));
    state = theme;
  }

  static ThemeData fromThemeName(String? themeName) {
    if (themeName == "lightTheme") return lightTheme;
    if (themeName == "darkTheme") return darkTheme;
    if (themeName == "trueBlackTheme") return trueBlackTheme;
    return darkTheme;
  }

  String themeName(ThemeData theme) {
    if (theme == lightTheme) return "lightTheme";
    if (theme == darkTheme) return "darkTheme";
    if (theme == trueBlackTheme) return "trueBlackTheme";
    return "darkTheme";
  }
}

ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Color(0xFFFFA826),
  colorScheme:
      ThemeData.light().colorScheme.copyWith(secondary: Color(0xFFFFA826)),
  indicatorColor: Color(0xFFFFA826),
  toggleableActiveColor: Color(0xFFFFA826),
  primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
  tabBarTheme: ThemeData().tabBarTheme.copyWith(
        unselectedLabelColor: Colors.grey,
        labelColor: Color(0xFFFFA826),
      ),
  appBarTheme: ThemeData().appBarTheme.copyWith(
        elevation: 0,
        color: Colors.white,
        iconTheme: ThemeData().iconTheme.copyWith(color: Colors.black),
      ),
  textTheme: ThemeData().textTheme.copyWith(
        caption: ThemeData().textTheme.caption?.copyWith(
              color: Colors.grey,
            ),
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Color(0xFF1F1F1F),
  primaryColor: Color(0xFFFFA826),
  colorScheme:
      ThemeData.light().colorScheme.copyWith(secondary: Color(0xFFFFA826)),
  indicatorColor: Color(0xFFFFA826),
  toggleableActiveColor: Color(0xFFFFA826),
  cardTheme: ThemeData().cardTheme.copyWith(
        color: Color(0xFF1C1C1C),
      ),
  appBarTheme: ThemeData().appBarTheme.copyWith(
        elevation: 0,
        color: Color(0xFF1F1F1F),
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData trueBlackTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.white,
  primaryColor: Color(0xFFFFA826),
  colorScheme:
      ThemeData.light().colorScheme.copyWith(secondary: Color(0xFFFFA826)),
  indicatorColor: Color(0xFFFFA826),
  toggleableActiveColor: Color(0xFFFFA826),
  cardTheme: ThemeData().cardTheme.copyWith(
        color: Color(0xFF1C1C1C),
      ),
  appBarTheme: ThemeData().appBarTheme.copyWith(
        elevation: 0,
        color: Colors.black,
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
