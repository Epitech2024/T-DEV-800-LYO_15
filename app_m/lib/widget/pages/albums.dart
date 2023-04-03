import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/widget/pages/feed.dart';
import 'package:app_m/widget/search_bar.dart';
import 'package:flutter/material.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  int _selectedIndex = 0;
  List<dynamic> _filteredAlbum = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  selectPhotos() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getAlbum(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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
                    child: Feed(
                  allImages: snapshot.data!,
                  filteredImages: _filteredAlbum,
                )),
              ),
            ]);
          } else {
            return const UnloadedFeed();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
