import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Apihelper {
  Future<List<dynamic>> fetchtodo() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response2 = await http.get(uri);
    final json = jsonDecode(response2.body);
    final result = json['items'] as List;
    return result;
  }

  Future<int> deleteById(String id, mytodo) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    
    return response.statusCode;
  }

  Future<int> updateData({title, description, id, context, mytodo}) async {
    var url = "https://api.nstack.in/v1/todos/$id";
    var uri = Uri.parse(url);
    final postbody = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final responce = await http.put(uri,
        body: jsonEncode(postbody),
        headers: {'Content-Type': 'application/json'});
    if (responce.statusCode == 200) {
      showSuccessMessage("successfully Updated", context);

      Navigator.of(context).pop(true);
      mytodo();
    } else {
      showfailedMessage("Updation failed", context);
    }
    return responce.statusCode;
  }

  Future<int> submitData({title, description, context, mytodo}) async {
    var url = "https://api.nstack.in/v1/todos";
    var uri = Uri.parse(url);
    final postbody = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final responce = await http.post(
      uri,
      body: jsonEncode(postbody),
      headers: {'Content-Type': 'application/json'},
    );

    print(responce.body);

    if (responce.statusCode == 201) {
      showSuccessMessage("successfully added", context);

      Navigator.of(context).pop();
      mytodo();
    } else {
      showfailedMessage("creation failed", context);
    }
    return responce.statusCode;
  }

  void showSuccessMessage(String message, context) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showfailedMessage(String message, context) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
