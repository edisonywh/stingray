import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stingray/model/item.dart';

class Repo {
  static get topStoriesUrl =>
      "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty";

  static Future<List<Item>> getTopStories() async {
    final response = await http.get(Repo.topStoriesUrl);
    if (response.statusCode == 200) {
      Iterable itemIds = jsonDecode(response.body);
      return Future.wait(itemIds.take(10).map((itemId) {
        return _getItem(itemId);
      }));
    } else {
      throw Exception("Unable to fetch data!");
    }
  }

  static Future<Item> _getItem(id) async {
    String url =
        "https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Future.value(Item.fromJson(response.body));
    } else {
      throw Exception("Unable to fetch data!");
    }
  }
}
