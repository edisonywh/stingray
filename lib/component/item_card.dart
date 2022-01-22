import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stingray/model/item.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(item.id.toString()),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.domain != "")
                Text(
                  item.domain,
                  style: Theme.of(context).textTheme.caption,
                ),
              if (item.type == StoryType.comment)
                Text(
                  "Comment",
                  style: Theme.of(context).textTheme.caption,
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8.0),
                child: item.type == StoryType.comment
                    ? Html(data: item.text)
                    : Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              Row(
                children: [
                  if (item.type != StoryType.comment) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            Feather.arrow_up,
                            size: 16,
                            color: item.isVoted()
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).iconTheme.color,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              item.score.toString(),
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            Feather.message_square,
                            size: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              item.descendants.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          Feather.clock,
                          size: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            item.ago,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
