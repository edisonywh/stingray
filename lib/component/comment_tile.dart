import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/page/profile.dart';
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
      Colors.lightBlue,
      Colors.pink,
      Colors.yellow,
      Colors.green,
      Colors.purple,
      Colors.red,
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
    return Stack(
      children: [
        Positioned.fill(
          top: 0,
          left: 0,
          right: 0,
          child: Row(
            children: List.generate(comment.depth, (i) => i)
                .map((d) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(width: 2, color: indentColor(d)),
                    ))
                .toList(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 18.0 * comment.depth,
            right: 16,
            bottom: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilePage(username: comment.by)),
                                ),
                            child: _buildAuthor(context, comment)),
                        if (comment.isVoted()) ...[
                          Text(
                            " ${String.fromCharCode(8226)}",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Icon(
                            Feather.arrow_up,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
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
                  ),
                  Spacer(),
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
              Html(
                data: comment.text,
                onLinkTap: (url) => launchUrl(url),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
