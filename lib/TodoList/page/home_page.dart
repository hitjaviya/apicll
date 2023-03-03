import 'dart:convert';
import 'package:apicll/TodoList/page/addtodopage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> items = [];
  @override
  void initState() {
    super.initState();
    fetchtodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todo-List",
        ),
      ),
      body: Visibility(
        replacement: Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: fetchtodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final id = item["_id"] as String;
              return ListTile(
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text(item['title']),
                subtitle: Text(item['description']),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == "edit") {
                      // edit page
                      navigatetoEditpage(item);
                    } else {
                      deleteById(id);
                    }
                  },
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(
                        child: Text("Edit"),
                        value: "edit",
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: "delete",
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigatetoaddpage,
        label: const Text("Add Page"),
      ),
    );
  }

  Future<void> navigatetoaddpage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(
        mytodo: fetchtodo,
      ),
    );
    await Navigator.push(context, route);
  }

  Future<void> navigatetoEditpage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(
        mytodo: fetchtodo,
        todo: item,
      ),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchtodo() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response2 = await http.get(uri);
    final json = jsonDecode(response2.body);
    final result = json['items'] as List;
    setState(() {
      items = result;
    });
  }

  Future<void> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/" + id;
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
  }
}
