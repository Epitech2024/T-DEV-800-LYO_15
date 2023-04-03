import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/widget/addPhotoDialog.dart';
import 'package:app_m/widget/pages/feed.dart';
import 'package:flutter/material.dart';

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getAlbum(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Feed(feedList: snapshot.data!);
          } else {
            return const UnloadedFeed();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addPhotoDialog();
        },
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
