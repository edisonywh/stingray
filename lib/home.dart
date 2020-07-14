import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stingray/model/story.dart';
import 'package:stingray/repo.dart';

final FutureProvider topStories = FutureProvider((ref) async {
  return await Repo.getTopStories();
});

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        (context, read) {
          return read(topStories).when(
            loading: () => Center(child: const CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
            data: (stories) {
              return ListView.builder(
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  Story story = stories[index];
                  return ListTile(
                    title: Text(
                      story.title,
                    ),
                    subtitle: Text(
                      "${story.formattedTime()} - ${story.by}",
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
