import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stingray/component/compact_tile.dart';
import 'package:stingray/component/item_card.dart';
import 'package:stingray/component/item_tile.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/page/story_page.dart';
import 'package:stingray/repo.dart';

final FutureProvider topStories = FutureProvider((ref) async {
  return await Repo.getTopStories();
});

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_controller.position.extentAfter <= 100) {
        print("Fetching..");
      }
    }
    return false;
  }

  _handleUpvote() {
    print("Handle upvote here");
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        (context, read) {
          return read(topStories).when(
            loading: () => Center(child: const CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (items) {
              return NotificationListener(
                onNotification: _handleScrollNotification,
                child: ListView.builder(
                  controller: _controller,
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
                          onTap: () => {},
                        ),
                      ],
                      dismissal: SlidableDismissal(
                        closeOnCanceled: true,
                        child: SlidableDrawerDismissal(),
                        onWillDismiss: (actionType) {
                          _handleUpvote();
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
                                    CompactTile(item: item),
                            openBuilder:
                                (BuildContext c, VoidCallback action) =>
                                    StoryPage(item: item),
                          )

                          // child: ItemCard(item: item),
                          // child: ItemTile(item: item),
                          // child: CompactTile(item: item),
                          ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
