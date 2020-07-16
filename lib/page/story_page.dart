import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:stingray/component/comment_tile.dart';
import 'package:stingray/component/part_snippet.dart';
import 'package:stingray/helpers.dart';
import 'package:stingray/model/item.dart';
import 'package:stingray/repo.dart';
import 'package:url_launcher/url_launcher.dart';

final commentsProvider = FutureProvider.family((ref, int parameter) async {
  return await Repo.fetchItem(parameter);
});

final partsProvider = FutureProvider.family((ref, int parameter) async {
  return await Repo.fetchItem(parameter);
});

class StoryPage extends HookWidget {
  const StoryPage({
    Key key,
    @required this.item,
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
  Widget build(BuildContext context) {
    final comments =
        item.kids.map((i) => useProvider(commentsProvider(i))).toList();
    final parts = item.parts.map((i) => useProvider(partsProvider(i))).toList();

    var anim = useAnimationController(
      duration: Duration(seconds: 1),
    );
    final Animation curve =
        CurvedAnimation(parent: anim, curve: Curves.easeInOut);

    anim.forward();

    return Scaffold(
      appBar: AppBar(
        title: Text('Stingray'),
        actions: [
          if (item.parent != null)
            IconButton(
              icon: Icon(Feather.corner_left_up),
              onPressed: () async {
                Item parent = await Repo.fetchItem(item.parent);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoryPage(item: parent)),
                );
              },
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () => launchUrl(item.url),
                          child: Container(
                            child: Text(
                              item.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            item.domain,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: item.ago,
                                style: Theme.of(context).textTheme.caption,
                              ),
                              TextSpan(
                                text: " ${String.fromCharCode(8226)} ",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              TextSpan(
                                text: item.by,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (item.text != "")
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              HtmlUnescape().convert(item.text),
                            ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
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
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            "${item.score}",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
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
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            item.descendants.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
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
                                onPressed: () => handleShare(item.id),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      bottom: 8.0,
                      right: 8.0,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: item.kids.length,
                      itemBuilder: (context, index) {
                        return SlideTransition(
                          position: Tween(
                            begin: Offset((index + 1) * -0.25, 0),
                            end: Offset(0, 0),
                          ).animate(
                            curve,
                          ),
                          child: CommentTile(
                            comment: comments[index],
                            depth: 0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Column(
                      children: [
                        Icon(
                          Feather.anchor,
                          size: 50,
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "This is the end!",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
