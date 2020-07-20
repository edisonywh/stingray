import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/component/loading_item.dart';
import 'package:stingray/component/story_list.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/repo.dart';

final StateProvider<ViewType> viewProvider = StateProvider((ref) {
  return ViewType.itemCard;
});

final storiesTypeProvider = FutureProvider.family((ref, type) async {
  return await Repo.getStories(type);
});

final storyProvider = FutureProvider.family((ref, id) async {
  return await Repo.fetchItem(id);
});

class StoriesPage extends HookWidget {
  const StoriesPage({
    Key key,
    @required this.type,
  }) : super(key: key);

  final StoriesType type;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      (context, read) {
        return read(storiesTypeProvider(type)).when(
          loading: () {
            // return SliverFillRemaining(
            // child: Center(child: CircularProgressIndicator()));
            return SliverToBoxAdapter(child: Center(child: LoadingItem()));
          },
          error: (err, stack) {
            print(err);
            return SliverToBoxAdapter(
                child: Center(child: Text('Error: $err')));
          },
          data: (ids) {
            return StoryList(ids: ids);
          },
        );
      },
    );
  }
}
