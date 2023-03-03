import 'dart:convert';

import 'dart:convert';

import '../model/user.dart';
import '../model/user_name.dart';

import 'package:http/http.dart' as http;

class UserApi {
  static Future<List<User>> fetchUsers() async {
    const String url = 'https://randomuser.me/api/?results=500';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final resullt = json['results'] as List<dynamic>;
    final users = resullt.map((e) {
      final name = Username(
          title: e['name']['title'],
          first: e['name']['first'],
          last: e['name']['last']);
      return User(
          gender: e['gender'],
          email: e['email'],
          phone: e['phone'],
          cell: e['cell'],
          nat: e['nat'],
          name: name);
    }).toList();
    return users;
  }
}
