import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/home.dart';
import 'package:stingray/theme.dart';

import 'package:timeago/timeago.dart' as timeago;

class CustomEn extends timeago.EnMessages {
  @override
  String suffixAgo() => '';
  String minutes(int minutes) => '${minutes}m';
  String hours(int hours) => '${hours}h';
  String days(int days) => '${days}d';
}

void main() {
  timeago.setLocaleMessages('en', CustomEn());
  runApp(ProviderScope(child: App()));
}

class App extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = useProvider(themeProvider).state;
    return MaterialApp(
      title: 'Stingray',
      theme: theme,
      home: Home(),
    );
  }
}
