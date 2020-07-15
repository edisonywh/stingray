import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/page/story_page.dart';

Color indentColor(int depth) {
  List<Color> colors = [
    Colors.lightBlue.shade900,
    Colors.pink.shade900,
    Colors.yellow.shade900,
    Colors.green.shade900,
    Colors.purple.shade900,
    Colors.red.shade900,
  ];

  int index = depth % colors.length;

  return colors[index];
}

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
    var anim = useAnimationController(duration: Duration(seconds: 2));
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
                    return FadeTransition(
                      opacity: anim,
                      child: Expandable(
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                        collapsed: Builder(
                          builder: (context) {
                            return ExpandComment(
                              controller: controller,
                              depth: depth,
                              item: item,
                            );
                          },
                        ),
                        expanded: Column(
                          children: [
                            ExpandComment(
                              controller: controller,
                              depth: depth,
                              item: item,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: item.kids.length,
                              itemBuilder: (context, index) {
                                return CommentTile(
                                  comment: comments[index],
                                  depth: depth + 1,
                                );
                              },
                            ),
                          ],
                        ),
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

class LoadingComment extends StatelessWidget {
  const LoadingComment({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(width: 80, height: 10, color: Colors.white24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(height: 10, color: Colors.white24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(height: 10, color: Colors.white24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(height: 10, color: Colors.white24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(height: 10, color: Colors.white24),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandComment extends StatelessWidget {
  const ExpandComment({
    Key key,
    @required this.item,
    @required this.controller,
    @required this.depth,
  }) : super(key: key);

  final Item item;
  final ExpandableController controller;
  final int depth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.toggle(),
      child: Card(
        shape: Border(
          left: BorderSide(width: 3.0, color: indentColor(depth)),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: item.ago,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          TextSpan(
                            text: " ${String.fromCharCode(8226)} ",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          TextSpan(
                            text: " ${String.fromCharCode(8226)} ",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          item.deleted
                              ? TextSpan(
                                  text: "<deleted>",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                )
                              : TextSpan(
                                  text: item.by,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                        ],
                      ),
                    ),
                    if (!controller.expanded && item.kids.length != 0)
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: Text(
                            "+${item.kids.length}",
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                HtmlUnescape().convert(item.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
