import 'dart:convert';

class Item {
  Item({
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
  String type;
  String url;

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["id"],
        by: json["by"] == null ? null : json["by"],
        deleted: json["deleted"] == null ? null : json["deleted"],
        text: json["text"] == null ? null : json["text"],
        dead: json["dead"] == null ? null : json["dead"],
        poll: json["poll"] == null ? null : json["poll"],
        parent: json["parent"] == null ? null : json["parent"],
        parts: json["parts"] == null
            ? []
            : List<int>.from(json["parts"].map((x) => x)),
        descendants: json["descendants"] == null ? null : json["descendants"],
        kids: json["kids"] == null
            ? []
            : List<int>.from(json["kids"].map((x) => x)),
        score: json["score"] == null ? null : json["score"],
        time: json["time"] == null ? null : json["time"],
        title: json["title"] == null ? null : json["title"],
        type: json["type"] == null ? null : json["type"],
        url: json["url"] == null ? null : json["url"],
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
}
