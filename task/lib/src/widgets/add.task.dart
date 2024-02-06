import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;
  const AddTaskPage({super.key, this.task});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.task != null) {
      _titleController = TextEditingController(text: widget.task!.title);
      _descriptionController =
          TextEditingController(text: widget.task!.description);
    }
    super.initState();
  }

  bool _validateFields() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(6, 10, 6, 0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ),
                    ))
              ],
            ),
            Expanded(
                child: ListView(
              padding: const EdgeInsets.fromLTRB(40, 0, 10, 0),
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.black, fontSize: 30),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Título',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
                ),
                TextField(
                  controller: _descriptionController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Descripción',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      )),
                ),
              ],
            ))
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_validateFields()) {
              Navigator.pop(context,
                  [_titleController.text, _descriptionController.text]);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, complete los campos'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          elevation: 10,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
