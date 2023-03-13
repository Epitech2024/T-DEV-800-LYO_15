import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String apiDomain = "localhost:3000";

Future<Image> getImageHttp(String _id) async {
  var client = http.Client();
  String params = '/images/one/$_id';

  try {
    var response =
        await client.get(Uri.http("192.168.122.1:3000", params), headers: {
      'Content-Type': 'application/json',
      'Authorization': '',
    });
    var decodedResponse = json.decode(response.body);
    List<dynamic> data = decodedResponse["img"]["data"];
    log(data.toString());
    List<int> bufferInt = data.map((e) => e as int).toList();
    client.close();
    return Image.memory(Uint8List.fromList(bufferInt));
  } catch (e) {
    log("ERROR: " + e.toString());
  }
  return Image.memory(Uint8List.fromList([0]));
  //Future<Image> payload =
  //    const Image(image: AssetImage('images/logo.png')) as Future<Image>;
}
