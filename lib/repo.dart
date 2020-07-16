import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stingray/model/item.dart';

class Repo {
  static final _itemsCache = <int, Item>{};

  static const baseUrl = "https://hacker-news.firebaseio.com/v0";

  static Future<List<Item>> getStories(StoriesType type) async {
    Iterable itemIds = await _getIds(type);

    return fetchByIds(itemIds);
  }

  static Future<List<Item>> fetchByIds(List<int> ids) async {
    return Future.wait(ids.take(50).map((itemId) {
      return fetchItem(itemId);
    }));
  }

  static Future<List<int>> _getIds(StoriesType type) async {
    final typeQuery = _getStoryTypeQuery(type);

    final url = "$baseUrl/$typeQuery.json";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<int> itemIds = List<int>.from(jsonDecode(response.body));
      return itemIds;
    } else {
      throw HackerNewsApiError('Stories for $typeQuery failed to fetch.');
    }
  }

  static Future<Item> fetchItem(int id) async {
    if (_itemsCache.containsKey(id)) {
      return _itemsCache[id];
    } else {
      // For some weird reason, sometimes the API returns "null".
      // e.g: "https://hacker-news.firebaseio.com/v0/item/23829504.json"
      String url = "$baseUrl/item/$id.json";
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return _itemsCache[id] = Item.fromJson(response.body);
      } else {
        throw HackerNewsApiError('Item $id failed to fetch.');
      }
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
      case StoriesType.askStories:
        return "askstories";
        break;
      case StoriesType.showStories:
        return "showstories";
        break;
      case StoriesType.jobStories:
        return "jobstories";
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
