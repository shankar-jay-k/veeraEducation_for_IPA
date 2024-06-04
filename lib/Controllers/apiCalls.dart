import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<Map<String, dynamic>> PostMethod(String url, Map<String, dynamic> body) async {
  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(body), // Encode the body as JSON string
  );

  Map<String, dynamic> responseData = json.decode(response.body);
  print('Post method response: $responseData');

  return responseData;
}


PutMethod(url,body) async {
  var responses = await http.put(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
      body:  body
  );
  List data = json.decode(responses.body);
  print('Put method response:${data}');

  return data;
}

Future<Map<String, dynamic>> GetMethod(String url) async {
  var response = await http.get(Uri.parse(url), headers: {
    "Accept": "application/json",
  });

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    print('Get method response: $data');
    return data;
  } else {
    throw Exception('Failed to load data from API');
  }
}

DeleteMethod(url) async{
  var response3 = await http.delete(Uri.parse(url),
      headers: {
        "Accept": "application/json",
      }
  );

  List deletedata = json.decode(response3.body);
  print('Delete method response:${deletedata}');

  return deletedata;

}