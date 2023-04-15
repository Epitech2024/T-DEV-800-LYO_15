import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

String apiDomain = "localhost:3000";

class ImageSelection {
  bool isSelected;
  Image image;

  ImageSelection({
    required this.isSelected,
    required this.image,
  });
}

ImageSelection getImageHttp(
  List data,
) {
  try {
    List<int> bufferInt = data.map((e) => e as int).toList();
    return ImageSelection(
        isSelected: false, image: Image.memory(Uint8List.fromList(bufferInt)));
  } catch (e) {
    log("ERROR: " + e.toString());
  }
  return ImageSelection(
      isSelected: false, image: Image.memory(Uint8List.fromList([0])));
  //Future<Image> payload =
  //    const Image(image: AssetImage('images/logo.png')) as Future<Image>;
}
