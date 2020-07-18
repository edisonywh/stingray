import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stingray/helpers.dart';
import 'package:stingray/model/item.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentTile extends HookWidget {
  const CommentTile({
    Key key,
    @required this.comment,
  }) : super(key: key);

  final Item comment;

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

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(true);
    return Padding(
      padding: EdgeInsets.only(left: comment.depth * 4.0),
      child: Slidable(
        key: Key(comment.id.toString()),
        actionPane: SlidableScrollActionPane(),
        actions: <Widget>[
          IconSlideAction(
            color: Colors.deepOrangeAccent,
            icon: Feather.arrow_up_circle,
            onTap: () => {},
          ),
        ],
        secondaryActions: [
          IconSlideAction(
            color: Colors.blue,
            icon: Feather.share_2,
            onTap: () => handleShare(comment.id),
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
            if (actionType == SlideActionType.secondary)
              handleShare(comment.id);
            return false;
          },
        ),
        child: Card(
          shape: Border(
            left: BorderSide(width: 3.0, color: indentColor(comment.depth)),
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
                              text: comment.ago,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            TextSpan(
                              text: " ${String.fromCharCode(8226)} ",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            comment.deleted
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
                                    text: comment.by,
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
                      if (!isExpanded.value && comment.kids.isNotEmpty)
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
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
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
      ),
    );
  }
}
