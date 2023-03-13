import 'dart:developer';
import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/widget/feed_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Feed extends StatefulWidget {
  final List<String> feedList;
  const Feed({super.key, required this.feedList});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Widget feedWidgetList(List<String> img_ids) {
    List<Widget> feed = [
      Row(children: [
        FeedTile(imageId: "63fe1f17f3d7a01f38fa64b0"),
        FeedTile(imageId: "63fe1f17f3d7a01f38fa64b0"),
        FeedTile(imageId: "63fe1f17f3d7a01f38fa64b0"),
      ])
      //const FeedTile(imageId: "63fe1f17f3d7a01f38fa64b0"),
      //const FeedTile(imageId: "63fe1f17f3d7a01f38fa64b0"),
    ];
    //for (int ids = 0; ids < img_ids.length; ids++) {
    //  //if (ids % 3 == 0) {
    //  feed.add(
    //    Row(
    //      mainAxisAlignment: MainAxisAlignment.center,
    //      crossAxisAlignment: CrossAxisAlignment.start,
    //      children: [
    //        FeedTile(imageId: img_ids[ids]),
    //        const FeedTile(imageId: "63fe1f17f3d7a01f38fa64b0"),
    //        const FeedTile(imageId: "63fe1f17f3d7a01f38fa64b0"),
    //      ],
    //    ),
    //  );
    //}
    //}

    //for (int i = 0; i < widget.feedList.length; i++) {
    //  log(widget.feedList[i].characters.string);
    //  feed.add(const FeedTile(imageId: "63fe1f17f3d7a01f38fa64b0"));
    //}
    return ListView(
      children: feed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return feedWidgetList(widget.feedList);
  }
}

class UnloadedFeed extends StatefulWidget {
  const UnloadedFeed({super.key});

  @override
  State<UnloadedFeed> createState() => _UnloadedFeedState();
}

class _UnloadedFeedState extends State<UnloadedFeed> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        //UnloadedFeedTile()
      ],
    );
  }
}
