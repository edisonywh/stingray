import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/component/compact_tile.dart';
import 'package:stingray/component/item_card.dart';
import 'package:stingray/component/item_tile.dart';
import 'package:stingray/component/loading_stories.dart';
import 'package:stingray/helpers.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/page/story_page.dart';
import 'package:stingray/repo.dart';

final StateProvider<ViewType> viewProvider = StateProvider((ref) {
  return ViewType.itemCard;
});

final storiesProvider = FutureProvider.family((ref, type) async {
  return await Repo.getStories(type);
});

enum ViewType {
  compactTile,
  itemCard,
  itemTile,
}

class StoriesPage extends HookWidget {
  const StoriesPage({
    Key key,
    @required this.type,
  }) : super(key: key);

  final StoriesType type;

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
    final currentView = useProvider(viewProvider);
    ScrollController scrollController = useScrollController();

    return Consumer(
      (context, read) {
        return read(storiesProvider(type)).when(
          loading: () {
            return LoadingStories();
          },
          error: (err, stack) {
            print(err);
            return Center(child: Text('Error: $err'));
          },
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
                        closedColor: Theme.of(context).scaffoldBackgroundColor,
                        openColor: Theme.of(context).scaffoldBackgroundColor,
                        transitionDuration: Duration(milliseconds: 500),
                        closedBuilder: (BuildContext c, VoidCallback action) =>
                            _getViewType(currentView.state, item),
                        openBuilder: (BuildContext c, VoidCallback action) =>
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
    );
  }
}
