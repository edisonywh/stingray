import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stingray/auth.dart';
import 'package:stingray/component/story_list.dart';
import 'package:stingray/model/user.dart';

class ProfilePage extends HookWidget {
  ProfilePage({this.username, this.isMe = false});

  final String username;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    AsyncValue<User> user = useProvider(usersProvider(username));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          username,
        ),
        actions: [
          if (isMe)
            IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Log out"),
                      content: Text("Are you sure you want to log out?"),
                      actions: [
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () async {
                            await Auth.logout();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Log out",
                            style: TextStyle(color: Colors.red[400]),
                          ),
                        ),
                      ],
                    );
                  }),
              icon: Icon(
                Feather.log_out,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: user.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, stacktrace) => Center(child: Text("$err")),
          data: (user) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "${user.karma}",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              TextSpan(
                                text: " ${String.fromCharCode(8226)} ",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              TextSpan(
                                text: user.since,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (user.about != null) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "About",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Html(
                        data: user.about,
                      ),
                    ),
                  ),
                ],
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Submissions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: StoryList(ids: user.submitted),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
