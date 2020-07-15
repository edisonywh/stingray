import 'package:flutter/material.dart';
import 'package:stingray/model/item.dart';

class StoryPage extends StatelessWidget {
  const StoryPage({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stingray'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            item.domain,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Card(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    margin: EdgeInsets.zero,
                    child: Padding(
                        padding: const EdgeInsets.all(
                          16.0,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: item.kids.length,
                          itemBuilder: (context, index) {
                            return Text(item.kids[index].toString());
                          },
                        )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
