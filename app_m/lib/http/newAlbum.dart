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

Future<bool> newAlbumHttp(List<String> images, String name) async {
  try {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'jwt');
    var api = dotenv.env['API'];
    Map<String, String> headers = {
      "Authorization": "Bearer ${token}",
    };
    Map<String, String> body = {"name": name, "img": images.toString()};
    print(body);
    var response = await http.post(Uri.parse("http://${api}/albums/new"),
        headers: headers, body: body);
    print(response);
    var res = response.body;
    print(res);
    //var decodedResponse = json.decode(response);
    //List<dynamic> data = decodedResponse;

    return true;
  } catch (e) {
    return false;
    log("ERROR: " + e.toString());
  }
  // return false;
  //Future<Image> payload =
  //    const Image(image: AssetImage('images/logo.png')) as Future<Image>;
}
