import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apicll/TodoList/services/api/api_helper.dart';

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
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titlecontroller,
            decoration: const InputDecoration(hintText: "title"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? _updateData : _submitData,
              child: Text(isEdit ? "Update" : "Submit"))
        ],
      ),
    );
  }

  Future<void> _updateData() async {
    final id = widget.todo!['_id'];
    final title = titlecontroller.text;
    final description = descriptionController.text;
    final statusCode = await Apihelper().updateData(
      context: context,
      description: description,
      title: title,
      id: id,
      mytodo: widget.mytodo,
    );
    if (statusCode == 200) {
      titlecontroller.text = "";
      descriptionController.text = "";
    }
  }

  Future<void> _submitData() async {
    final title = titlecontroller.text;
    final description = descriptionController.text;
    final statusCode = await Apihelper().submitData(
      context: context,
      description: description,
      title: title,
      mytodo: widget.mytodo,
    );
    if (statusCode == 201) {
      titlecontroller.text = "";
      descriptionController.text = "";
    }
  }
}
