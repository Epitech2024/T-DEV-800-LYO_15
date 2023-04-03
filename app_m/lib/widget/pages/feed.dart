import 'dart:developer';
import 'package:app_m/widget/feed_tile.dart';
import 'package:app_m/widget/picture_frame.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  final List<dynamic> allImages;
  final List<dynamic> filteredImages;
  const Feed(
      {super.key, required this.allImages, required this.filteredImages});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Widget feedWidgetList(List<dynamic> images) {
    List<Widget> feed = [];
    int rows = ((images.length / 3)).round();
    int left = images.length % 3;

    if (left > 0) {
      rows++;
    }
    log("Rows: $rows");
    List<Widget> row = [];
    for (int i = 0; i + 1 <= images.length; i++) {
      if (((i + 1) % 3 == 0 && i != 0)) {
        images[i].isNotEmpty
            ? row.add(
                Expanded(child: PictureFrame(data: images[i]["img"]["data"])))
            : row.add(const UnloadedFeedTile());
        feed.add(Row(children: row));
        row = [];
      } else if (i + 1 == images.length) {
        images[i].isNotEmpty
            ? row.add(
                Expanded(child: PictureFrame(data: images[i]["img"]["data"])))
            : row.add(const UnloadedFeedTile());
        feed.add(Row(children: row));
      } else {
        images[i].isNotEmpty
            ? row.add(
                Expanded(child: PictureFrame(data: images[i]["img"]['data'])))
            : row.add(const UnloadedFeedTile());
      }
    }
    ListView view = ListView.builder(
        itemCount: feed.length,
        itemBuilder: (context, index) {
          return Material(
              child: ListTile(
            title: feed[index],
          ));
        });
    return view;
  }

  @override
  Widget build(BuildContext context) {
    return feedWidgetList(widget.filteredImages.isEmpty
        ? widget.allImages
        : widget.filteredImages);
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
