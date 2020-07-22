import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/component/comment_tile.dart';
import 'package:stingray/component/loading_item.dart';
import 'package:stingray/helpers.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/repo.dart';

final commentsProvider = FutureProvider.family((ref, int id) async {
  return await Repo.fetchItem(id);
});

class CommentList extends HookWidget {
  const CommentList({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    useMemoized(() => Repo.prefetchComments(item: item));

    final collapsed = useState(Set());
    final comments = useState([]);

    Stream<Item> stream;

    useEffect(() {
      stream = Repo.lazyFetchComments(item: item);
      final sub = stream.listen((Item comment) {
        Set result = Set.from(collapsed.value);
        if (collapsed.value.contains(comment.parent)) {
          result.add(comment.id);
        }
        comments.value = [...comments.value, comment];
        collapsed.value = result;
      });
      return sub.cancel;
    }, [stream]);

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            Set result = Set.from(collapsed.value);
            Widget _child;

            if (comments.value.isEmpty || index > comments.value.length - 1) {
              _child = LoadingItem(count: 1);
            } else {
              Item comment = comments.value[index];

              _child = InkWell(
                onTap: () async {
                  if (collapsed.value.contains(comment.id)) {
                    result.remove(comment.id);
                  } else {
                    result.add(comment.id);
                    List<int> ids = await Repo.getCommentsIds(item: comment);
                    result.addAll(ids);
                  }
                  collapsed.value = result;
                },
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: collapsed.value.contains(comment.parent)
                      ? Container()
                      : Slidable(
                          key: Key(comment.id.toString()),
                          closeOnScroll: true,
                          actionPane: SlidableScrollActionPane(),
                          actions: <Widget>[
                            IconSlideAction(
                              color: Colors.deepOrangeAccent,
                              icon: Feather.arrow_up_circle,
                              onTap: () {
                                handleUpvote(context, item: comment);
                              },
                            ),
                          ],
                          dismissal: SlidableDismissal(
                            closeOnCanceled: true,
                            dismissThresholds: {
                              SlideActionType.primary: 0.2,
                              SlideActionType.secondary: 0.2,
                            },
                            child: SlidableDrawerDismissal(),
                            onWillDismiss: (actionType) {
                              handleUpvote(context, item: comment);
                              return false;
                            },
                          ),
                          child: CommentTile(
                            comment: comments.value[index],
                            author: item.by,
                            isCollapsed: collapsed.value.contains(comment.id),
                          ),
                        ),
                ),
              );
            }

            return AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              duration: Duration(seconds: 1),
              child: _child,
            );
          },
          childCount: item.descendants,
        ),
      ),
    );
  }
}
