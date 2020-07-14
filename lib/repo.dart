import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stingray/model/item.dart';

enum StoriesType {
  topStories,
  newStories,
  bestStories,
}

class Repo {
  static const baseUrl = "https://hacker-news.firebaseio.com/v0";

  static Future<List<Item>> getTopStories() async {
    Iterable itemIds = await _getIds(StoriesType.topStories);

    return Future.wait(itemIds.take(10).map((itemId) {
      return _getItem(itemId);
    }));
  }

  static Future<List<int>> _getIds(StoriesType type) async {
    final typeQuery = _getStoryTypeQuery(type);

    final url = "$baseUrl/$typeQuery.json";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<int> itemIds = List<int>.from(jsonDecode(response.body));
      return Future.value(itemIds);
    } else {
      throw HackerNewsApiError('Stories for $typeQuery failed to fetch.');
    }
  }

  static Future<Item> _getItem(id) async {
    String url = "$baseUrl/item/$id.json";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Future.value(Item.fromJson(response.body));
    } else {
      throw HackerNewsApiError('Article $id failed to fetch.');
    }
  }

  static String _getStoryTypeQuery(StoriesType type) {
    switch (type) {
      case StoriesType.bestStories:
        return "beststories";
      case StoriesType.newStories:
        return "newstories";
        break;
      case StoriesType.topStories:
        return "topstories";
        break;
      default:
        return "none";
    }
  }
}

class HackerNewsApiError extends Error {
  final String message;

  HackerNewsApiError(this.message);
}
