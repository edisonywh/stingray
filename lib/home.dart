import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/deeplink_handler.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/page/stories_page.dart';
import 'package:stingray/repo.dart';
import 'package:stingray/theme.dart';

final FutureProvider newStories = FutureProvider((ref) async {
  return await Repo.getStories(StoriesType.newStories);
});

final FutureProvider bestStories = FutureProvider((ref) async {
  return await Repo.getStories(StoriesType.bestStories);
});

final FutureProvider askStories = FutureProvider((ref) async {
  return await Repo.getStories(StoriesType.askStories);
});

final FutureProvider showStories = FutureProvider((ref) async {
  return await Repo.getStories(StoriesType.showStories);
});

final FutureProvider jobStories = FutureProvider((ref) async {
  return await Repo.getStories(StoriesType.jobStories);
});

class Home extends HookWidget {
  final List tabs = [
    "Top",
    "New",
    "Best",
    "Show HN",
    "Ask",
    "Jobs",
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final currentView = useProvider(viewProvider);
    final currentTheme = useProvider(themeProvider);

    useMemoized(() => DeeplinkHandler.init(context));
    useEffect(() => DeeplinkHandler.cancel, const []);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Consumer((context, read) {
              return IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Theme"),
                      children: [
                        RadioListTile(
                          title: const Text('Light'),
                          value: lightTheme,
                          groupValue: currentTheme.state,
                          onChanged: (value) {
                            themeProvider.read(context).state = value;
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('Dark'),
                          value: darkTheme,
                          groupValue: currentTheme.state,
                          onChanged: (value) {
                            themeProvider.read(context).state = value;
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('True Black'),
                          value: trueBlackTheme,
                          groupValue: currentTheme.state,
                          onChanged: (value) {
                            themeProvider.read(context).state = value;
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                ),
                icon: Icon(
                  Feather.moon,
                ),
              );
            }),
            IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                        title: Text("Customize view"),
                        children: <Widget>[
                          RadioListTile(
                            title: const Text('Card'),
                            value: ViewType.itemCard,
                            groupValue: currentView.state,
                            onChanged: (value) {
                              viewProvider.read(context).state = value;
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            title: const Text('Compact'),
                            value: ViewType.compactTile,
                            groupValue: currentView.state,
                            onChanged: (value) {
                              viewProvider.read(context).state = value;
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            title: const Text('Tile'),
                            value: ViewType.itemTile,
                            groupValue: currentView.state,
                            onChanged: (value) {
                              viewProvider.read(context).state = value;
                              Navigator.pop(context);
                            },
                          ),
                        ]);
                  }),
              icon: Icon(
                Feather.grid,
              ),
            )
          ],
          title: Text(
            'Stingray',
            style: TextStyle(
              fontSize: 32,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Theme.of(context).primaryColor,
            ),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            onTap: (i) => currentIndex.value = i,
            tabs: tabs.map((tab) {
              return Tab(
                child: Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(tab),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              StoriesPage(type: StoriesType.topStories),
              StoriesPage(type: StoriesType.newStories),
              StoriesPage(type: StoriesType.bestStories),
              StoriesPage(type: StoriesType.showStories),
              StoriesPage(type: StoriesType.askStories),
              StoriesPage(type: StoriesType.jobStories),
            ],
          ),
        ),
      ),
    );
  }
}
