import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share/share.dart';
import 'package:stingray/component/story_information.dart';
import 'package:stingray/component/user_modal.dart';
import 'package:stingray/model/user.dart';
import 'package:stingray/repo.dart';

void handleShare(int id) {
  String url = "https://news.ycombinator.com/item?id=$id";

  String text =
      "Hey, check out this Hacker News story that I read via Stingray!\r\r $url";

  Share.share(text);
}

void showUserModal(BuildContext context, {String username}) async {
  showModalBottomSheet(
    context: context,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    builder: (context) {
      return UserModal(username: username);
    },
  );
}
