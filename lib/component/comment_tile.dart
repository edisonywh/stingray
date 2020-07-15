import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/page/story_page.dart';

Color indentColor(int depth) {
  List<Color> colors = [
    Colors.lightBlue.shade900,
    Colors.pink.shade900,
    Colors.yellow.shade900,
    Colors.green.shade900,
    Colors.purple.shade900,
    Colors.purple.shade900,
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
    return comment.when(
      loading: () => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SpinKitThreeBounce(
            size: 20,
            color: Theme.of(context).accentColor,
          ),
        ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
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
                        child: RichText(
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
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        HtmlUnescape().convert(item.text),
                      ),
                    ],
                  ),
                ),
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
              )
            ],
          ),
        );
      },
    );
  }
}
