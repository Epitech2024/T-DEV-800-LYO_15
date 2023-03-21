import 'dart:developer';
import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/widget/feed_tile.dart';
import 'package:app_m/widget/picture_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Feed extends StatefulWidget {
  final List<dynamic> feedList;
  const Feed({super.key, required this.feedList});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Widget feedWidgetList(List<dynamic> imgIds) {
    List<Widget> feed = [];
    int rows = ((imgIds.length / 3)).round();
    int left = imgIds.length % 3;

    if (left > 0) {
      rows++;
    }

    log("Rows: $rows");

    List<Widget> row = [];
    for (int i = 0; i + 1 <= imgIds.length; i++) {
      if (((i + 1) % 3 == 0 && i != 0)) {
        imgIds[i].isNotEmpty ? log(imgIds[i]) : log("?");
        imgIds[i].isNotEmpty
            ? row.add(Expanded(child: PictureFrame(id: imgIds[i])))
            : row.add(const UnloadedFeedTile());
        feed.add(Row(children: row));
        row = [];
      } else if (i + 1 == imgIds.length) {
        imgIds[i].isNotEmpty ? log(imgIds[i]) : log("?");
        imgIds[i].isNotEmpty
            ? row.add(Expanded(child: PictureFrame(id: imgIds[i])))
            : row.add(const UnloadedFeedTile());
        feed.add(Row(children: row));
      } else {
        imgIds[i].isNotEmpty ? log(imgIds[i]) : log("?");
        imgIds[i].isNotEmpty
            ? row.add(Expanded(child: PictureFrame(id: imgIds[i])))
            : row.add(const UnloadedFeedTile());
      }
    }
    ListView view = ListView.builder(
        itemCount: feed.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: feed[index],
          );
        });
    return view;
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
