import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stingray/model/item.dart';

class Repo {
  static final _itemsCache = <int, Item>{};

  static const baseUrl = "https://hacker-news.firebaseio.com/v0";

  static Future<List<int>> getStories(StoriesType type) async {
    return await _getIds(type);
  }

  /// Takes in an Item and fetches all of its
  /// descendant in flat, sorted order.
  /// It is important to fetch a flattened list for optimized
  /// UI rendering. The other alternative I've tried is to
  /// render the list recursively, but nested ListView is
  /// expensive to render.
  static Future<List<Item>> fetchDescendants(
      {Item item, int depth = 0, prefetch = false}) async {
    List<Item> result = [];
    if (item.parent != null) result.add(item);
    if (item.kids.isEmpty) return Future.value(result);

    if (prefetch) {
      await Future.wait(item.kids.map((kidId) async {
        Item kid = await fetchItem(kidId);
        await fetchDescendants(item: kid, depth: 0, prefetch: true);
      }));
    } else {
      await Future.forEach(item.kids, ((kidId) async {
        Item kid = await fetchItem(kidId);
        kid.depth = depth;
        List<Item> grandkids =
            await fetchDescendants(item: kid, depth: depth + 1);
        result.addAll(grandkids);
      }));
    }

    return Future.value(result);
  }

  static Future<List<Item>> fetchByIds(List<int> ids) async {
    return Future.wait(ids.map((itemId) {
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
