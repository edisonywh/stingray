import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:stingray/helpers.dart';
import 'package:stingray/model/item.dart';

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

class ExpandableComment extends StatelessWidget {
  const ExpandableComment({
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
    return Slidable(
      key: Key(item.id.toString()),
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
          if (actionType == SlideActionType.secondary) handleShare(item.id);
          return false;
        },
      ),
      child: InkWell(
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
                Text(
                  HtmlUnescape().convert(item.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
