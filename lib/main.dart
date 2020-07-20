import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stingray/home.dart';
import 'package:stingray/theme.dart';
import 'package:stingray/view_manager.dart';

import 'package:timeago/timeago.dart' as timeago;

class CustomEn extends timeago.EnMessages {
  @override
  String suffixAgo() => '';
  String minutes(int minutes) => '${minutes}m';
  String hours(int hours) => '${hours}h';
  String days(int days) => '${days}d';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  timeago.setLocaleMessages('en', CustomEn());
  SharedPreferences pref = await SharedPreferences.getInstance();

  String themeName = pref.getString('theme');
  final theme = ThemeManager.fromThemeName(themeName);

  String viewName = pref.getString('view');
  final view = ViewManager.fromViewName(viewName);

  runApp(ProviderScope(child: App(theme: theme, view: view)));
}

class App extends HookWidget {
  const App({@required this.theme, @required this.view});

  final ThemeData theme;
  final ViewType view;

  @override
  Widget build(BuildContext context) {
    final themeManager = useProvider(themeProvider);
    final viewManager = useProvider(viewProvider);
    useMemoized(() {
      // TODO: Right now this triggers a rebuild, so unfortunately you'll see a flash of default theme.
      themeManager.setTheme(theme);
      viewManager.setView(view);
    });

    final currentTheme = useProvider(themeProvider.state);

    return MaterialApp(
      title: 'Stingray',
      theme: currentTheme,
      home: Home(),
    );
  }
}
