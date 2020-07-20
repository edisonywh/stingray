import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stingray/model/item.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentTile extends HookWidget {
  const CommentTile({
    Key key,
    @required this.comment,
    @required this.author,
    this.isCollapsed = false,
  }) : super(key: key);

  final Item comment;
  final String author;
  final bool isCollapsed;

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

  void launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildAuthor(BuildContext context, Item comment) {
    if (comment.deleted) {
      return Text(
        "<deleted>",
        style: Theme.of(context).textTheme.caption.copyWith(
              fontStyle: FontStyle.italic,
            ),
      );
    }

    if (comment.by == author) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
          ),
          child: Text(
            comment.by,
            style: Theme.of(context).textTheme.caption.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      );
    }

    return Text(
      comment.by,
      style: Theme.of(context).textTheme.caption.copyWith(
            fontWeight: FontWeight.w500,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: comment.depth * 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            left: BorderSide(width: 3.0, color: indentColor(comment.depth)),
          ),
        ),
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
                    Row(
                      children: [
                        _buildAuthor(context, comment),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: " ${String.fromCharCode(8226)} ",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              TextSpan(
                                text: comment.ago,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isCollapsed && comment.kids.isNotEmpty)
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
                            "+${comment.kids.length}",
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
              Html(
                data: comment.text,
                onLinkTap: (url) => launchUrl(url),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
