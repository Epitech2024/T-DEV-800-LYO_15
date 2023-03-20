import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String apiDomain = "localhost:3000";

Future<bool> postImageHttp(String _userId, File image) async {
  try {
    var request = http.MultipartRequest(
        'POST', Uri.http("192.168.122.1:3000", "/images"));
    Map<String, String> headers = {"Content-type": "multipart/form-data"};

    request.files.add(
      http.MultipartFile(
        'photo',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: "img",
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    request.headers.addAll(headers);
    request.fields.addAll({
      "userId": _userId,
    });
    var response = await request.send();
    var res = await response.stream.bytesToString();
    print(res);
    //var decodedResponse = json.decode(response);
    //List<dynamic> data = decodedResponse;
    log(response.toString());
    return true;
  } catch (e) {
    log("ERROR: " + e.toString());
    return false;
  }
  return false;
  //Future<Image> payload =
  //    const Image(image: AssetImage('images/logo.png')) as Future<Image>;
}
