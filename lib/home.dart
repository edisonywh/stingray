import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/deeplink_handler.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/page/settings.dart';
import 'package:stingray/page/stories_page.dart';
import 'package:stingray/repo.dart';

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
    required this.name,
    required this.icon,
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
                title: Text(
                  'Stingray',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                actions: [
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    ),
                    icon: Icon(Feather.settings),
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  tabs: tabs.map((tab) {
                    return Tab(
                      child: Row(
                        children: [
                          Icon(
                            tab.icon,
                            size: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(tab.name),
                          ),
                        ],
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
                top: false,
                bottom: false,
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
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          sliver: StoriesPage(
                            type: type,
                          ),
                        )
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
