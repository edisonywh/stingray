import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:stingray/auth.dart';
import 'package:stingray/history.dart';
import 'package:stingray/model/item.dart';

void handleShare(
    {required int id, required String title, required String postUrl}) {
  String hnUrl = buildHackerNewsURL(id);

  String text =
      "Read it on Hacker News: $hnUrl \r\r or go straight to the article: $postUrl";

  Share.share(text, subject: title);
}

String buildHackerNewsURL(int id) {
  return "https://news.ycombinator.com/item?id=$id";
}

void handleUpvote(context, {required Item item}) async {
  HistoryManager.addToVoteCache(item.id);
  AuthResult result = await Auth.vote(itemId: "${item.id}");

  if (result.result == Result.error) {
    HistoryManager.removeFromVoteCache(
        item.id); // ToDO: The UI won't update when we remove from cache here.
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result.message)));
  } else if (result.result == Result.ok) {
    await HistoryManager.markAsVoted(item.id);
  }
}
