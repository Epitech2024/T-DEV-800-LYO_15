import 'dart:convert';

import 'package:app_m/http/newAlbum.dart';
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

class AddDialog extends StatefulWidget {
  final bool album;
  final List<String>? images;
  const AddDialog({super.key, this.album = false, this.images});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final TextEditingController _textFieldController = TextEditingController();
  String? codeDialog;
  String? valueText;
  Future<void> addName() async {
    if (!widget.album) {
      ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String? path = image.path;
        File imageFile = File(path);

        bool posted = await postImageHttp(imageFile, valueText!);
        if (posted == true) {
          Navigator.pop(context);
          log("Post successful");
        } else {
          log("Post failed");
        }
      }
    } else {
      bool posted = await newAlbumHttp(widget.images!, valueText!);
      if (posted == true) {
        Navigator.pop(context);
        log("Post successful");
      } else {
        log("Post failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Name for your ${!widget.album ? "photo" : "Album"}"),
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
          color: Colors.green,
          textColor: Colors.white,
          child: const Text('OK'),
          onPressed: () async {
            setState(() {
              codeDialog = valueText;
            });
            print(valueText);
            if (valueText != null) {
              await addName();
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
  }
}
