import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/component/comment_tile.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/repo.dart';

final commentsProvider = FutureProvider.family((ref, int parameter) async {
  return await Repo.fetchItem(parameter);
});

class StoryPage extends HookWidget {
  const StoryPage({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    final comments =
        item.kids.map((i) => useProvider(commentsProvider(i))).toList();

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
                                text: item.descendants.toString(),
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
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: item.kids.length,
                      itemBuilder: (context, index) {
                        return CommentTile(
                          comment: comments[index],
                          depth: 0,
                        );
                      },
                    ),
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
