import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stingray/component/compact_tile.dart';
import 'package:stingray/component/item_card.dart';
import 'package:stingray/component/item_tile.dart';
import 'package:stingray/component/loading_stories.dart';
import 'package:stingray/deeplink_handler.dart';
import 'package:stingray/helpers.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/page/story_page.dart';
import 'package:stingray/repo.dart';

final FutureProvider topStories = FutureProvider((ref) async {
  return await Repo.getTopStories();
});

enum ViewType {
  compactTile,
  itemCard,
  itemTile,
}

class Home extends HookWidget {
  final List tabs = [
    "Top",
    "New",
    "Best",
    "Show HN",
    "Ask",
    "Jobs",
  ];

  _handleUpvote() {
    print("Handle upvote here");
    return false;
  }

  _getViewType(ViewType type, Item item) {
    switch (type) {
      case ViewType.compactTile:
        return CompactTile(item: item);
        break;
      case ViewType.itemCard:
        return ItemCard(item: item);
        break;
      case ViewType.itemTile:
        return ItemTile(item: item);
        break;
      default:
        return ItemCard(item: item);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final currentView = useState(ViewType.itemCard);

    useMemoized(() => DeeplinkHandler.init(context));
    useEffect(() => DeeplinkHandler.cancel, const []);
    ScrollController scrollController = useScrollController();

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
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
                            groupValue: currentView.value,
                            onChanged: (value) {
                              currentView.value = value;
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            title: const Text('Compact'),
                            value: ViewType.compactTile,
                            groupValue: currentView.value,
                            onChanged: (value) {
                              currentView.value = value;
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            title: const Text('Tile'),
                            value: ViewType.itemTile,
                            groupValue: currentView.value,
                            onChanged: (value) {
                              currentView.value = value;
                              Navigator.pop(context);
                            },
                          ),
                        ]);
                  }),
              icon: Icon(
                Feather.pie_chart,
              ),
            )
          ],
          title: Text(
            'Stingray',
            style: TextStyle(
              fontSize: 32,
              color: Theme.of(context).primaryColor,
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
          child: Consumer(
            (context, read) {
              return read(topStories).when(
                loading: () {
                  return LoadingStories();
                },
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (items) {
                  return NotificationListener(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        if (scrollController.position.extentAfter <= 100) {
                          print("Fetching..");
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        Item item = items[index];
                        return Slidable(
                          key: Key(item.id.toString()),
                          actionPane: SlidableScrollActionPane(),
                          actions: <Widget>[
                            IconSlideAction(
                              color: Colors.deepOrangeAccent,
                              icon: Feather.arrow_up_circle,
                              onTap: () => _handleUpvote(),
                            ),
                          ],
                          secondaryActions: [
                            IconSlideAction(
                              color: Colors.blue,
                              icon: Feather.share_2,
                              onTap: () => handleShare(item.id),
                            ),
                          ],
                          dismissal: SlidableDismissal(
                            dismissThresholds: {
                              SlideActionType.primary: 0.2,
                              SlideActionType.secondary: 0.2,
                            },
                            closeOnCanceled: true,
                            child: SlidableDrawerDismissal(),
                            onWillDismiss: (actionType) {
                              actionType == SlideActionType.primary
                                  ? _handleUpvote()
                                  : handleShare(item.id);
                              return false;
                            },
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 2),
                            child: OpenContainer(
                              tappable: true,
                              closedElevation: 0,
                              closedColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              openColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              transitionDuration: Duration(milliseconds: 500),
                              closedBuilder:
                                  (BuildContext c, VoidCallback action) =>
                                      _getViewType(currentView.value, item),
                              openBuilder:
                                  (BuildContext c, VoidCallback action) =>
                                      StoryPage(item: item),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
