import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stingray/repo.dart';

final usersProvider = FutureProvider.family((ref, String id) async {
  return await Repo.fetchUser(id);
});

class User {
  User({
    this.about,
    this.created,
    this.delay,
    this.id,
    this.karma,
    this.submitted,
  });

  String about;
  int created;
  int delay;
  String id;
  int karma;
  List<int> submitted;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  get since {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(created * 1000);
    final DateFormat formatter = DateFormat('dd MMMM yyyy');

    return formatter.format(time);
  }

  factory User.fromMap(Map<String, dynamic> json) => User(
        about: json["about"] == null ? null : json["about"],
        created: json["created"] == null ? null : json["created"],
        delay: json["delay"] == null ? null : json["delay"],
        id: json["id"] == null ? null : json["id"],
        karma: json["karma"] == null ? null : json["karma"],
        submitted: json["submitted"] == null
            ? null
            : List<int>.from(json["submitted"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "about": about == null ? null : about,
        "created": created == null ? null : created,
        "delay": delay == null ? null : delay,
        "id": id == null ? null : id,
        "karma": karma == null ? null : karma,
        "submitted": submitted == null
            ? null
            : List<dynamic>.from(submitted.map((x) => x)),
      };
}
