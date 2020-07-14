import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stingray/model/story.dart';

class Repo {
  static get topStoriesUrl =>
      "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty";

  static Future<List<Story>> getTopStories() async {
    final response = await http.get(Repo.topStoriesUrl);
    if (response.statusCode == 200) {
      Iterable storyIds = jsonDecode(response.body);
      return Future.wait(storyIds.take(10).map((storyId) {
        return _getStory(storyId);
      }));
    } else {
      throw Exception("Unable to fetch data!");
    }
  }

  static Future<Story> _getStory(id) async {
    String url =
        "https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Future.value(Story.fromJson(response.body));
    } else {
      throw Exception("Unable to fetch data!");
    }
  }
}
