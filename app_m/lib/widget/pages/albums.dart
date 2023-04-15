import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/http/getAllImages.dart';
import 'package:app_m/widget/addDialog.dart';
import 'package:app_m/widget/feed_tile.dart';
import 'package:app_m/widget/pages/albumFeed.dart';
import 'package:app_m/widget/pages/feed.dart';
import 'package:app_m/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  bool albumSelection = false;
  List<String> selectedImages = [];

  createAlbum() async {
    print(selectedImages);
    if (selectedImages.isEmpty) {
      Fluttertoast.showToast(
        msg: "No image selected",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      final result = await showDialog(
        context: context,
        builder: (context) => AddDialog(
          album: true,
          images: selectedImages,
        ),
      );
      albumSelection = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Album'),
          actions: [
            Visibility(
              visible: albumSelection,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                color: Colors.red,
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    albumSelection = false;
                  });
                },
              ),
            ),
            Visibility(
              visible: albumSelection,
              child: IconButton(
                icon: const Icon(
                  Icons.check,
                ),
                color: Colors.green,
                iconSize: 30,
                onPressed: () {
                  createAlbum();
                  // Handle the confirmation of the selected images here
                },
              ),
            )
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: !albumSelection ? getAlbum() : getAllImages(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(children: [
                Container(
                  child: SearchBar(
                    images: snapshot.data!,
                    onFilter: (filteredList) {
                      // setState(() {
                      //   _filteredAlbum = filteredList;
                      // });
                    },
                  ),
                ),
                Container(
                  child: Expanded(
                      child: !albumSelection
                          ? AlbumFeed(
                              allImages: snapshot.data!,
                              selectedImages: selectedImages,
                              album: albumSelection,
                            )
                          : Feed(
                              allImages: snapshot.data!,
                              album: albumSelection,
                              selectedImages: selectedImages,
                            )),
                ),
              ]);
            } else {
              return const UnloadedFeedTile();
            }
          },
        ),
        floatingActionButton: Visibility(
          visible: !albumSelection,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                albumSelection = true;
              });
            },
            tooltip: 'add',
            child: const Icon(Icons.add),
          ),
        ));
  }
}
