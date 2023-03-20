import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String apiDomain = "localhost:3000";

Future<List<String>> getAlbum() async {
  var client = http.Client();
  String params = '/images/papa44';

  try {
    var response =
        await client.get(Uri.http("192.168.122.1:3000", params), headers: {
      'Content-Type': 'application/json',
      'Authorization': '',
    });
    var decodedResponse = json.decode(response.body);
    List<dynamic> data = decodedResponse;
    List<String> images = [];
    for (int i = 0; i < data.length; i++) {
      images.add(data[i]["_id"]);
    }
    client.close();
    return images;
  } catch (e) {
    log("ERROR: " + e.toString());
  }
  return [];
  //Future<Image> payload =
  //    const Image(image: AssetImage('images/logo.png')) as Future<Image>;
}
