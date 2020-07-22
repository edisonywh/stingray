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
    this.by,
    this.deleted,
    this.text,
    this.dead,
    this.poll,
    this.parent,
    this.parts,
    this.descendants,
    this.id,
    this.kids,
    this.score,
    this.time,
    this.title,
    this.type,
    this.url,
  });

  int depth;
  String by;
  bool deleted;
  String text;
  bool dead;
  int poll;
  int parent;
  List<int> parts;
  int descendants;
  int id;
  List<int> kids;
  int score;
  int time;
  String title;
  StoryType type;
  String url;

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  bool isVoted() => HistoryManager.isVoted(id);

  String get domain => Uri.parse(url)?.host;
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
        "by": by == null ? null : by,
        "deleted": deleted == null ? null : deleted,
        "text": text == null ? null : text,
        "dead": dead == null ? null : dead,
        "poll": poll == null ? null : poll,
        "parent": parent == null ? null : parent,
        "parts": parts == null ? null : List<dynamic>.from(parts.map((x) => x)),
        "descendants": descendants == null ? null : descendants,
        "kids": kids == null ? null : List<dynamic>.from(kids.map((x) => x)),
        "score": score == null ? null : score,
        "time": time == null ? null : time,
        "title": title == null ? null : title,
        "type": type == null ? null : type,
        "url": url == null ? null : url,
      };

  static StoryType castType(String type) {
    switch (type) {
      case "job":
        return StoryType.job;
        break;
      case "story":
        return StoryType.story;
        break;
      case "comment":
        return StoryType.comment;
        break;
      case "poll":
        return StoryType.poll;
        break;
      case "pollopt":
        return StoryType.pollopt;
        break;
      default:
        return null;
        break;
    }
  }
}
