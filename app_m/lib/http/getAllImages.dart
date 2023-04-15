import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<List<dynamic>> getAllImages() async {
  String apiDomain = dotenv.env['API']!;
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt');
  var client = http.Client();
  String params = '/images/all';
  try {
    var response = await client.get(Uri.http(apiDomain, params), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    });
    var decodedResponse = json.decode(response.body);
    if (decodedResponse.runtimeType != String) {
      List<dynamic> data = decodedResponse;
      client.close();
      return data;
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    log("ERROR: " + e.toString());
  }
  return [];
  //Future<Image> payload =
  //    const Image(image: AssetImage('images/logo.png')) as Future<Image>;
}
