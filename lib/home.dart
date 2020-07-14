import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stingray/model/story.dart';
import 'package:stingray/repo.dart';

final FutureProvider topStories = FutureProvider((ref) async {
  return await Repo.getTopStories();
});

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_controller.position.extentAfter <= 500) {
        print("Fetching..");
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        (context, read) {
          return read(topStories).when(
            loading: () => Center(child: const CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
            data: (stories) {
              return NotificationListener(
                onNotification: _handleScrollNotification,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    Story story = stories[index];
                    return ListTile(
                      onTap: () {},
                      title: Text(
                        story.title,
                      ),
                      subtitle: Text(
                        "${story.kids.length.toString()} comments",
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
