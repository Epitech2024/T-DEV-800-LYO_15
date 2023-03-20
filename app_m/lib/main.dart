import 'dart:developer';
import 'dart:io';

import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/http/getFeed.dart';
import 'package:app_m/http/postImage.dart';
import 'package:app_m/widget/feed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:app_m/http/getFeed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  ImagePicker _picker = ImagePicker();

  Future<void> _incrementCounter() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    String path = image!.path;
    File imageFile = File(path);

    bool posted = await postImageHttp("papa44", imageFile);
    if (posted == true) {
      log("Post successful");
    } else {
      log("Post failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //actions: const <Widget>[
      //Stories
      //FutureBuilder(
      //    future: getUserStories(),
      //    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
      //      switch (snapshot.connectionState) {
      //        case ConnectionState.done:
      //          break;
      //        case ConnectionState.waiting:
      //        case ConnectionState.none:
      //        default:
      //      }
      //    })
      //],
      // ),
      body: Center(
        child: FutureBuilder(
            future: getAlbum(), //remplace by getFeed
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Feed(feedList: snapshot.data!);
                case ConnectionState.waiting:
                case ConnectionState.none:
                default:
                  return const UnloadedFeed();
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
