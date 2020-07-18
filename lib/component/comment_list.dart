import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/component/comment_tile.dart';
import 'package:stingray/component/loading_stories.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/repo.dart';

final commentsProvider = FutureProvider.family((ref, Item item) async {
  await Repo.fetchDescendants(item: item, prefetch: true);
  return await Repo.fetchDescendants(item: item);
});

class CommentList extends HookWidget {
  const CommentList({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      (context, read) {
        return read(commentsProvider(item)).when(
          loading: () {
            return SliverToBoxAdapter(child: LoadingStories());
          },
          error: (err, stack) {
            return SliverToBoxAdapter(
                child: Center(child: Text('Error: $err')));
          },
          data: (comments) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return CommentTile(
                    comment: comments[index],
                    author: item.by,
                  );
                },
                childCount: comments.length,
              ),
            );
          },
        );
      },
    );
  }
}
