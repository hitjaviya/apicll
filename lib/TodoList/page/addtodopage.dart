import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apicll/TodoList/page/home_page.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  final Function mytodo;

  const AddToDoPage({
    super.key,
    required this.mytodo,
    this.todo,
  });

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  List items = [];
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titlecontroller.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit ToDo" : "Add ToDo ")),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titlecontroller,
            decoration: InputDecoration(hintText: "title"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(isEdit ? "Update" : "Submit"),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    print("Update data cll");
    final id = widget.todo!['_id'];
    var url = "https://api.nstack.in/v1/todos/$id";
    var uri = Uri.parse(url);
    final title = titlecontroller.text;
    final description = descriptionController.text;
    final postbody = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final responce = await http.put(uri,
        body: jsonEncode(postbody),
        headers: {'Content-Type': 'application/json'});
    print(responce.statusCode);
    print(responce.body);
    if (responce.statusCode == 200) {
      titlecontroller.text = "";
      descriptionController.text = "";
      showSuccessMessage("successfully Updated");

      Navigator.of(context).pop(true);
      widget.mytodo();
    } else {
      showfailedMessage("Updation failed");
    }
  }

  Future<void> submitData() async {
    var url = "https://api.nstack.in/v1/todos";
    var uri = Uri.parse(url);

    final title = titlecontroller.text;
    final description = descriptionController.text;
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
      titlecontroller.text = "";
      descriptionController.text = "";

      showSuccessMessage("successfully Add");

      Navigator.of(context).pop();
      widget.mytodo();
    } else {
      showfailedMessage("creation failed");
    }
  }

  void showSuccessMessage(String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showfailedMessage(String message) {
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
