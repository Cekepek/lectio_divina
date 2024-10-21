import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/class/ld.dart';
import 'package:http/http.dart' as http;
import 'package:lectio_divina/core.dart';

String urlApi = "http://sw.crossnet.co.id:5868";

Future<Map<dynamic, dynamic>> connectApi(
    String url, String method, dynamic body) async {
  if (method == "post") {
    final response = await http.post(Uri.parse(urlApi + url), body: body);
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      // ResponseRequest responseRequest = ResponseRequest(
      //   response.statusCode,
      // );
      return json;
    } else {
      Map json = jsonDecode(response.body);
      return {"error": json["data"].toString()};
    }
  } else if (method == "get") {
    final response = await http.get(Uri.parse(urlApi + url));
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);

      return json;
    } else {
      Map json = jsonDecode(response.body);
      return {"error": json["data"].toString()};
    }
  } else {
    final response = await http.delete(Uri.parse(urlApi + url), body: body);
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      return json;
    } else {
      Map json = jsonDecode(response.body);
      return {"error": json["data"].toString()};
    }
  }
}
