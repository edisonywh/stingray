import 'dart:convert';

import 'package:stingray/history.dart';
import 'package:timeago/timeago.dart' as timeago;

enum StoryType {
  job,
  story,
  comment,
  poll,
  pollopt,
}

enum StoriesType {
  topStories,
  newStories,
  bestStories,
  askStories,
  showStories,
  jobStories,
}

class Item {
  Item({
    this.depth = 0,
    required this.by,
    required this.deleted,
    required this.text,
    required this.dead,
    required this.poll,
    required this.parent,
    required this.parts,
    required this.descendants,
    required this.id,
    this.kids = const [],
    required this.score,
    required this.time,
    required this.title,
    required this.type,
    required this.url,
  });

  int depth;
  final String by;
  final bool deleted;
  final String? text;
  final bool? dead;
  final int? poll;
  final int? parent;
  final List<int> parts;
  final int? descendants;
  final int id;
  final List<int> kids;
  final int score;
  final int time;
  final String title;
  final StoryType? type;
  final String url;

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  bool isVoted() => HistoryManager.isVoted(id);

  String get domain => url;
  String get ago =>
      timeago.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["id"],
        by: json["by"] == null ? "" : json["by"],
        deleted: json["deleted"] == null ? false : json["deleted"],
        text: json["text"] == null ? "" : json["text"],
        dead: json["dead"] == null ? false : json["dead"],
        poll: json["poll"] == null ? null : json["poll"],
        parent: json["parent"] == null ? null : json["parent"],
        parts: json["parts"] == null
            ? []
            : List<int>.from(json["parts"].map((x) => x)),
        descendants: json["descendants"] == null ? 0 : json["descendants"],
        kids: json["kids"] == null
            ? []
            : List<int>.from(json["kids"].map((x) => x)),
        score: json["score"] == null ? 0 : json["score"],
        time: json["time"] == null ? 0 : json["time"],
        title: json["title"] == null ? "" : json["title"],
        type: json["type"] == null ? null : castType(json["type"]),
        url: json["url"] == null ? "" : json["url"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "by": by,
        "deleted": deleted,
        "text": text == null ? null : text,
        "dead": dead == null ? null : dead,
        "poll": poll == null ? null : poll,
        "parent": parent,
        "parts": List<dynamic>.from(parts.map((x) => x)),
        "descendants": descendants == null ? null : descendants,
        "kids": List<dynamic>.from(kids.map((x) => x)),
        "score": score,
        "time": time,
        "title": title,
        "type": type == null ? null : type,
        "url": url,
      };

  static StoryType castType(String type) {
    switch (type) {
      case "job":
        return StoryType.job;
      case "story":
        return StoryType.story;
      case "comment":
        return StoryType.comment;
      case "poll":
        return StoryType.poll;
      case "pollopt":
        return StoryType.pollopt;
      default:
        throw Exception("Unknown type: $type");
    }
  }
}
