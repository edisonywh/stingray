import 'dart:convert';

class Story {
  Story({
    this.by,
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
  int descendants;
  int id;
  List<int> kids;
  int score;
  int time;
  String title;
  String type;
  String url;

  factory Story.fromJson(String str) => Story.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  formattedTime() {
    var date = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    return "${date.day}/${date.month}/${date.year}";
  }

  factory Story.fromMap(Map<String, dynamic> json) => Story(
        id: json["id"],
        by: json["by"] == null ? null : json["by"],
        descendants: json["descendants"] == null ? null : json["descendants"],
        kids: json["kids"] == null
            ? null
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
        "descendants": descendants == null ? null : descendants,
        "kids": kids == null ? null : List<dynamic>.from(kids.map((x) => x)),
        "score": score == null ? null : score,
        "time": time == null ? null : time,
        "title": title == null ? null : title,
        "type": type == null ? null : type,
        "url": url == null ? null : url,
      };
}
