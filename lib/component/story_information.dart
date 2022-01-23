import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/component/part_snippet.dart';
import 'package:stingray/helpers.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/page/profile.dart';
import 'package:stingray/repo.dart';
import 'package:url_launcher/url_launcher.dart';

final partsProvider = FutureProvider.family((ref, int id) async {
  return await Repo.fetchItem(id);
});

class StoryInformation extends HookConsumerWidget {
  const StoryInformation({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  void launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parts = item.parts.map((i) => ref.watch(partsProvider(i))).toList();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => launchUrl(item.url),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  child: Text(
                    item.title == "" ? "Comment" : item.title,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
            if (item.domain != "")
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  item.domain,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(username: item.by)),
                );
              },
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: item.by,
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    TextSpan(
                      text: " ${String.fromCharCode(8226)} ",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    TextSpan(
                      text: item.ago,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
            if (item.text != "")
              Html(
                data: item.text,
                onLinkTap: (url, _, __, ___) => launchUrl(url),
              ),
            if (item.parts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: item.parts.length,
                  itemBuilder: (context, index) {
                    return PartSnippet(part: parts[index]);
                  },
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            Feather.arrow_up,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "${item.score}",
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).textTheme.caption?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            Feather.message_square,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              item.descendants.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Feather.share_2,
                  ),
                  onPressed: () => handleShare(
                      id: item.id, title: item.title, postUrl: item.url),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
