import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stingray/repo.dart';

final usersProvider = FutureProvider.family((ref, String id) async {
  return await Repo.fetchUser(id);
});

class User {
  User({
    required this.about,
    required this.created,
    required this.delay,
    required this.id,
    required this.karma,
    required this.submitted,
  });

  final String? about;
  final int created;
  final int delay;
  final String id;
  final int karma;
  final List<int> submitted;

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
        submitted: List<int>.from(json["submitted"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "about": about,
        "created": created,
        "delay": delay,
        "id": id,
        "karma": karma,
        "submitted": List<dynamic>.from(submitted.map((x) => x)),
      };
}
