import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stingray/component/comment_list.dart';
import 'package:stingray/component/story_information.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/repo.dart';

class StoryPage extends HookWidget {
  const StoryPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stingray'),
        actions: [
          if (item.parent != null)
            IconButton(
              icon: Icon(Feather.corner_left_up),
              onPressed: () async {
                Item parent = await Repo.fetchItem(item.parent!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoryPage(item: parent)),
                );
              },
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: StoryInformation(item: item)),
          CommentList(item: item),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: Column(
                  children: [
                    Icon(
                      Feather.anchor,
                      size: 50,
                      color: Theme.of(context).textTheme.caption?.color,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "This is the end!",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.caption?.color,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
