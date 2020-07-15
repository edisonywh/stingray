import 'package:flutter/material.dart';
import 'package:stingray/model/item.dart';

class CompactTile extends StatelessWidget {
  const CompactTile({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                text: "  ${item.score} ",
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              TextSpan(
                text: " ${item.descendants}  ",
                style: Theme.of(context).textTheme.caption,
              ),
              TextSpan(
                text: '${item.domain}',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
