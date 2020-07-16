import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/component/expandable_comment.dart';
import 'package:stingray/component/loading_comment.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/page/story_page.dart';

class CommentTile extends HookWidget {
  const CommentTile({
    Key key,
    @required this.comment,
    @required this.depth,
  }) : super(key: key);

  final AsyncValue<Item> comment;
  final int depth;

  @override
  Widget build(BuildContext context) {
    var anim = useAnimationController(
      duration: Duration(seconds: 1),
    );
    final Animation curve =
        CurvedAnimation(parent: anim, curve: Curves.easeInOut);

    anim.forward();

    return comment.when(
      loading: () => Padding(
        padding: const EdgeInsets.only(
          left: 4,
        ),
        child: LoadingComment(),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (item) {
        final comments =
            item.kids.map((i) => useProvider(commentsProvider(i))).toList();
        return Padding(
          padding: new EdgeInsets.only(
            left: 4,
            bottom: depth == 0 ? 16 : 6,
          ),
          child: ExpandableNotifier(
            key: Key(item.id.toString()),
            initialExpanded: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    var controller = ExpandableController.of(context);
                    return Expandable(
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                      collapsed: Builder(
                        builder: (context) {
                          return ExpandableComment(
                            controller: controller,
                            depth: depth,
                            item: item,
                          );
                        },
                      ),
                      expanded: Column(
                        children: [
                          ExpandableComment(
                            controller: controller,
                            depth: depth,
                            item: item,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: item.kids.length,
                            itemBuilder: (context, index) {
                              return SlideTransition(
                                position: Tween(
                                  begin: Offset((index + 1) * -0.25, 0),
                                  end: Offset(0, 0),
                                ).animate(
                                  curve,
                                ),
                                child: CommentTile(
                                  comment: comments[index],
                                  depth: depth + 1,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
