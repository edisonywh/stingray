import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stingray/model/item.dart';

class CompactTile extends StatelessWidget {
  const CompactTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: item.type == StoryType.comment
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        "${item.ago}",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Expanded(
                        child: Html(
                          data: item.text,
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: item.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "  ${item.score}p",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                color: item.isVoted()
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).iconTheme.color,
                              ),
                        ),
                        TextSpan(
                          text: " ${String.fromCharCode(8226)} ",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        TextSpan(
                          text: "${item.descendants}",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        TextSpan(
                          text: " ${String.fromCharCode(8226)} ",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        TextSpan(
                          text: '${item.domain}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        TextSpan(
                          text: " ${String.fromCharCode(8226)} ",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        TextSpan(
                          text: '${item.ago}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        Divider(),
      ],
    );
  }
}
