import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:stingray/auth.dart';
import 'package:stingray/history.dart';
import 'package:stingray/model/item.dart';

void handleShare(int id) {
  String url = "https://news.ycombinator.com/item?id=$id";

  String text =
      "Hey, check out this Hacker News story that I read via Stingray!\r\r $url";

  Share.share(text);
}

void handleUpvote(context, {Item item}) async {
  HistoryManager.addToVoteCache(item.id);
  AuthResult result = await Auth.vote(itemId: "${item.id}");

  if (result.result == Result.error) {
    HistoryManager.removeFromVoteCache(
        item.id); // ToDO: The UI won't update when we remove from cache here.
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(result.message)));
  } else if (result.result == Result.ok) {
    await HistoryManager.markAsVoted(item.id);
  }
}
