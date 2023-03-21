import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_m/http/getAlbum.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String apiDomain = "localhost:3000";

Future<bool> postImageHttp(File image) async {
  try {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'jwt');
    var api = dotenv.env['API'];
    var request = http.MultipartRequest('POST', Uri.http(api!, "/images/add"));
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer ${token}"
    };

    // image
    request.files.add(
      http.MultipartFile(
        'photo',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: "img",
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.fields.addAll({"name": "test"});
    request.headers.addAll(headers);
    var response = await request.send();
    var res = await response.stream.bytesToString();
    print(res);
    //var decodedResponse = json.decode(response);
    //List<dynamic> data = decodedResponse;

    return true;
  } catch (e) {
    log("ERROR: " + e.toString());
    return false;
  }
  return false;
  //Future<Image> payload =
  //    const Image(image: AssetImage('images/logo.png')) as Future<Image>;
}
