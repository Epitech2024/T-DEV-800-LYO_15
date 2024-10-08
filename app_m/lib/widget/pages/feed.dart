import 'dart:developer';
import 'package:app_m/widget/feed_tile.dart';
import 'package:app_m/widget/picture_frame.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  final List<dynamic> allImages;
  final List<String>? selectedImages;
  final bool album;
  const Feed(
      {super.key,
      this.selectedImages,
      required this.allImages,
      required this.album});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  void handleSelection(String id) {
    print(id);
    if (widget.selectedImages!.contains(id)) {
      widget.selectedImages!.remove(id);
    } else {
      widget.selectedImages!.add(id);
    }
  }

  Widget feedWidgetList(List<dynamic> images) {
    print(widget.album);
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
            ? row.add(Expanded(
                child: PictureFrame(
                onSelectionChanged: (String id) {
                  handleSelection(id);
                },
                data: images[i]["img"]["data"],
                id: images[i]["_id"],
                toBeselected: widget.album,
              )))
            : row.add(const UnloadedFeedTile());
        feed.add(Row(children: row));
        row = [];
      } else if (i + 1 == images.length) {
        images[i].isNotEmpty
            ? row.add(Expanded(
                child: PictureFrame(
                onSelectionChanged: (String id) {
                  handleSelection(id);
                },
                data: images[i]["img"]["data"],
                id: images[i]["_id"],
                toBeselected: widget.album,
              )))
            : row.add(const UnloadedFeedTile());
        feed.add(Row(children: row));
      } else {
        images[i].isNotEmpty
            ? row.add(Expanded(
                child: PictureFrame(
                onSelectionChanged: (String id) {
                  handleSelection(id);
                },
                data: images[i]["img"]['data'],
                id: images[i]["_id"],
                toBeselected: widget.album,
              )))
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
    return feedWidgetList(widget.allImages);
  }
}
