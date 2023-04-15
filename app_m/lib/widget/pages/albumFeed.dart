import 'dart:developer';
import 'package:app_m/widget/feed_tile.dart';
import 'package:app_m/widget/picture_frame.dart';
import 'package:app_m/widget/thumbnail.dart';
import 'package:flutter/material.dart';

class AlbumFeed extends StatefulWidget {
  final List<dynamic> allImages;
  final List<String>? selectedImages;
  final bool album;
  const AlbumFeed(
      {super.key,
      this.selectedImages,
      required this.allImages,
      required this.album});

  @override
  State<AlbumFeed> createState() => _AlbumFeedState();
}

class _AlbumFeedState extends State<AlbumFeed> {
  void handleSelection(String id) {
    print(id);
    if (widget.selectedImages!.contains(id)) {
      widget.selectedImages!.remove(id);
    } else {
      widget.selectedImages!.add(id);
    }
  }

  Widget feedWidgetList(List<dynamic> albums) {
    List<Widget> feed = [];
    int rows = ((albums.length / 3)).round();
    int left = albums.length % 3;

    if (left > 0) {
      rows++;
    }
    log("Rows: $rows");
    List<Widget> row = [];
    for (int i = 0; i + 1 <= albums.length; i++) {
      if (((i + 1) % 3 == 0 && i != 0)) {
        albums[i] != ''
            ? row.add(Expanded(
                child: ImageThumbnail(
                images: albums[i]["images"],
                albumId: albums[i]["id"],
              )))
            : row.add(const UnloadedFeedTile());
        feed.add(Row(children: row));
        row = [];
      } else if (i + 1 == albums.length) {
        albums[i].toString() != ''
            ? row.add(Expanded(
                child: ImageThumbnail(
                images: albums[i]["images"],
                albumId: albums[i]["id"],
              )))
            : row.add(const UnloadedFeedTile());
        feed.add(Row(children: row));
      } else {
        albums[i] != ''
            ? row.add(Expanded(
                child: ImageThumbnail(
                images: albums[i]["images"],
                albumId: albums[i]["id"],
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
