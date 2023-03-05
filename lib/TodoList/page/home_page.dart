import 'package:apicll/TodoList/page/addtodopage.dart';
import 'package:flutter/material.dart';
import 'package:apicll/TodoList/services/api/api_helper.dart';

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
    _fetchtodo();
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
        replacement: const Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: _fetchtodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final id = item["_id"];
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    _deleteById(id);
                  } else {
                    navigatetoEditpage(item);
                  }
                },
                background: Container(
                  padding: const EdgeInsets.only(left: 10),
                  color: Colors.blue,
                  child: Row(children: const [
                    Icon(
                      Icons.add_card,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Edit")
                  ]),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Icon(
                          Icons.delete,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Delete"),
                      ]),
                ),
                child: ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == "edit") {
                        // edit page
                        navigatetoEditpage(item);
                      } else {
                        _deleteById(id);
                      }
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem(
                          value: "edit",
                          child: Text("Edit"),
                        ),
                        PopupMenuItem(
                          value: "delete",
                          child: Text("Delete"),
                        ),
                      ];
                    },
                  ),
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
        mytodo: _fetchtodo,
      ),
    );
    await Navigator.push(context, route);
  }

  Future<void> navigatetoEditpage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(
        mytodo: _fetchtodo,
        todo: item,
      ),
    );
    Navigator.push(context, route);
  }

  Future<void> _fetchtodo() async {
    final result = await Apihelper().fetchtodo();
    setState(() {
      items = result;
    });
  }

  Future<void> _deleteById(String id) async {
    final statusCode = await Apihelper().deleteById(id, _fetchtodo);
    if (statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
  }
}
