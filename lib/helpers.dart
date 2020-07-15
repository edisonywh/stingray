import 'package:share/share.dart';

void handleShare(int id) {
  String url = "https://news.ycombinator.com/item?id=$id";

  String text =
      "Hey, check out this Hacker News story that I read via Stingray!\r\r $url";

  Share.share(text);
}
