import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_m/http/getImage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String apiDomain = "192.168.122.1";

Future<List<String>> sendFuture() async {
  await Future.delayed(const Duration(seconds: 1));
  log("sending feed");
  return ["papa44"];
}

Future<List<String>> getFeed(String _userId) async {
  var client = http.Client();
  String params = '/images/$_userId';

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
    return sendFuture();
  } catch (e) {
    log("ERROR: " + e.toString());
  }
  client.close();

  return sendFuture();
}
