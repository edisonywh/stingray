import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/component/story_list.dart';
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

class IconTab {
  IconTab({
    this.name,
    this.icon,
  });

  final String name;
  final IconData icon;
}

class Home extends HookWidget {
  final List tabs = [
    IconTab(name: "Top", icon: Feather.trending_up),
    IconTab(name: "New", icon: Feather.star),
    IconTab(name: "Best", icon: Feather.award),
    IconTab(name: "Show", icon: Feather.eye),
    IconTab(name: "Ask", icon: Feather.mic),
    IconTab(name: "Jobs", icon: Feather.briefcase),
  ];

  @override
  Widget build(BuildContext context) {
    final currentView = useProvider(viewProvider);
    final currentTheme = useProvider(themeProvider);

    useMemoized(() => DeeplinkHandler.init(context));
    useEffect(() => DeeplinkHandler.cancel, const []);

    return DefaultTabController(
      length: tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                context,
              ),
              sliver: SliverAppBar(
                title: const Text('Stingray'),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
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
                bottom: TabBar(
                  isScrollable: true,
                  tabs: tabs.map((tab) {
                    return Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              tab.icon,
                              size: 18,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(tab.name),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            StoriesType.topStories,
            StoriesType.newStories,
            StoriesType.bestStories,
            StoriesType.showStories,
            StoriesType.askStories,
            StoriesType.jobStories
          ].map((type) {
            return Scaffold(
              body: SafeArea(
                child: Builder(
                  builder: (context) {
                    return CustomScrollView(
                      key: PageStorageKey(type),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context,
                          ),
                        ),
                        // SliverPadding(
                        // padding: const EdgeInsets.symmetric(vertical: 8.0),
                        // sliver: StoriesPage(
                        // type: type,
                        // ),
                        // )
                        StoriesPage(
                          type: type,
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
