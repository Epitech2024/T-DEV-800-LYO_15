import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/http/getAllImages.dart';
import 'package:app_m/widget/addDialog.dart';
import 'package:app_m/widget/feed_tile.dart';
import 'package:app_m/widget/pages/feed.dart';
import 'package:flutter/material.dart';

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getAllImages(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Feed(
              allImages: snapshot.data!,
              album: false,
            );
          } else {
            return const UnloadedFeedTile();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddDialog(album: false),
          );
        },
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
