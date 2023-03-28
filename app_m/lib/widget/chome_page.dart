import 'dart:developer';
import 'dart:io';

import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/http/postImage.dart';
import 'package:app_m/widget/feed.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  int _counter = 0;
  ImagePicker _picker = ImagePicker();

  String? codeDialog;
  String? valueText;

  Future<void> addPhoto() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? path = image.path;
      File imageFile = File(path);

      bool posted = await postImageHttp(imageFile);
      if (posted == true) {
        log("Post successful");
      } else {
        log("Post failed");
      }
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Name for your photo'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    valueText = '';
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () async {
                  setState(() {
                    codeDialog = valueText;
                  });
                  print(valueText);
                  if (valueText != null) {
                    await addPhoto();
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                      msg: "Choose a name before sending !",
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          _displayTextInputDialog(context);
        },
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
