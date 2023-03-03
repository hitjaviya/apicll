import 'package:apicll/Apicll/model/user.dart';
import 'package:apicll/Apicll/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Api CLL")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: ((context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(child: Text("${index + 1}")),
            title: Text(user.name.first),
            subtitle: Text(user.email),
          );
        }),
      ),
    );
  }

  void fetchUsers() async {
    final response = await UserApi.fetchUsers();
    setState(() {
      users = response;
    });
  }
}
