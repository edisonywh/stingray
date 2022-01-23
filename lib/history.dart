import "package:hive_flutter/hive_flutter.dart";

class HistoryManager {
  static Set _votedCache = {};

  static init() async {
    await Hive.initFlutter();

    var box = await Hive.openBox('box');

    List _votedItems = box.get('votedItems', defaultValue: []);
    Set result = listToSet(_votedItems);
    _votedCache = result;
  }

  static bool isVoted(itemId) {
    return _votedCache.contains(itemId);
  }

  static bool addToVoteCache(itemId) {
    return _votedCache.add(itemId);
  }

  static bool removeFromVoteCache(itemId) {
    return _votedCache.remove(itemId);
  }

  static Future markAsVoted(itemId) async {
    var box = await Hive.openBox('box');

    addToVoteCache(itemId);

    List _votedItems = box.get('votedItems', defaultValue: []);
    List newList = [..._votedItems, itemId];

    box.put('votedItems', newList);

    return await Future.value(null); // This is to ensure the cache is updated.
  }

  static Set listToSet(List list) {
    Set result = Set();

    for (var i in list) {
      result.add(i);
    }

    return result;
  }
}
