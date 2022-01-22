import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/auth.dart';
import 'package:stingray/page/login.dart';
import 'package:stingray/page/profile.dart';
import 'package:stingray/theme.dart';
import 'package:stingray/view_manager.dart';

class SettingsPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentView = ref.read(viewProvider);
    final ViewManager viewManager =
        ref.watch<ViewManager>(viewProvider.notifier);
    final currentTheme = ref.watch<ThemeData>(themeProvider);
    final ThemeManager themeManager =
        ref.read<ThemeManager>(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stingray",
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text("Theme"),
              leading: Icon(Feather.moon),
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) => SimpleDialog(
                      title: Text("Theme"),
                      children: [
                        RadioListTile(
                          title: const Text('Light'),
                          value: lightTheme,
                          groupValue: currentTheme,
                          onChanged: (value) {
                            themeManager.setTheme(value);
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('Dark'),
                          value: darkTheme,
                          groupValue: currentTheme,
                          onChanged: (value) {
                            themeManager.setTheme(value);
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('True Black'),
                          value: trueBlackTheme,
                          groupValue: currentTheme,
                          onChanged: (value) {
                            themeManager.setTheme(value);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text("View"),
              leading: Icon(Feather.grid),
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text("View"),
                    children: <Widget>[
                      RadioListTile(
                        title: const Text('Card'),
                        value: ViewType.itemCard,
                        groupValue: currentView,
                        onChanged: (value) {
                          viewManager.setView(value);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile(
                        title: const Text('Compact'),
                        value: ViewType.compactTile,
                        groupValue: currentView,
                        onChanged: (value) {
                          viewManager.setView(value);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile(
                        title: const Text('Tile'),
                        value: ViewType.itemTile,
                        groupValue: currentView,
                        onChanged: (value) {
                          viewManager.setView(value);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Feather.user),
              title: Text("My Profile"),
              onTap: () async {
                Widget page;
                bool isLoggedIn = await Auth.isLoggedIn();
                if (!isLoggedIn) {
                  page = LoginPage();
                } else {
                  var username = await Auth.currentUser();

                  page = ProfilePage(username: username, isMe: true);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
