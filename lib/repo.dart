import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stingray/model/item.dart';

class Repo {
  static final _itemsCache = <int, Item>{};

  static const baseUrl = "https://hacker-news.firebaseio.com/v0";

  static Future<List<int>> getStories(StoriesType type) async {
    return await _getIds(type);
  }

  static Future<List<int>> getCommentsIds({Item item}) async {
    Stream<Item> stream = lazyFetchComments(item: item, assignDepth: false);
    List<int> comments = [];

    await for (Item comment in stream) {
      comments.add(comment.id);
    }

    return comments;
  }

  static Stream<Item> lazyFetchComments(
      {Item item, int depth = 0, bool assignDepth = true}) async* {
    if (item.kids.isEmpty) return;

    for (int kidId in item.kids) {
      Item kid = await fetchItem(kidId);
      if (kid == null) continue;

      if (assignDepth) kid.depth = depth;

      yield kid;

      Stream stream = lazyFetchComments(item: kid, depth: kid.depth + 1);
      await for (Item grandkid in stream) {
        yield grandkid;
      }
    }
  }

  /// Takes in an Item and fetches all of its
  /// descendant in flat, non-sorted order.
  ///
  /// This mostly exists so that I can fetch items async,
  /// put them in a cache, so that later I can retrieve them
  /// in a sorted order.
  static Future<List<Item>> prefetchComments({Item item}) async {
    List<Item> result = [];
    if (item.parent != null) result.add(item);
    if (item.kids.isEmpty) return Future.value(result);

    await Future.wait(item.kids.map((kidId) async {
      Item kid = await fetchItem(kidId);
      if (kid != null) {
        await prefetchComments(item: kid);
      }
    }));

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
        if (response.body == "null") return null;
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
