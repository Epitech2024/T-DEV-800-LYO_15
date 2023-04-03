import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:developer';
import 'dart:io';

import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/http/postImage.dart';
import 'package:app_m/widget/bottom_navigation.dart';
import 'package:app_m/widget/pages/feed.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class addPhotoDialog extends StatefulWidget {
  const addPhotoDialog({super.key});

  @override
  State<addPhotoDialog> createState() => _addPhotoDialogState();
}

class _addPhotoDialogState extends State<addPhotoDialog> {
  final TextEditingController _textFieldController = TextEditingController();

  String? codeDialog;
  String? valueText;
  Future<void> addPhoto() async {
    ImagePicker _picker = ImagePicker();
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
                    // Navigator.pop(context);
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
                    // Navigator.pop(context);
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
    return Container();
  }
}
