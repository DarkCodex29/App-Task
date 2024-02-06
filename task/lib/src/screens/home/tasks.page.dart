import 'package:flutter/material.dart';
import 'package:task/src/widgets/add.task.dart';
import 'package:task/src/widgets/tasks.list.dart';
import '../../models/task.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> sampleTask = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Tareas',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 50,
              ),
            ),
          ),
        ),
        body: _buildBody(),
        floatingActionButton: _addTask(context),
      ),
    );
  }

  Widget _buildBody() {
    if (sampleTask.isEmpty) {
      return const Center(
        child: Text(
          'No hay tareas',
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return TasksList(tasks: sampleTask);
    }
  }

  Widget _addTask(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const AddTaskPage(),
          ),
        );
        if (result != null) {
          setState(() {
            sampleTask.add(Task(
              id: sampleTask.length,
              title: result[0],
              description: result[1],
            ));
          });
        }
      },
      elevation: 10,
      child: const Icon(Icons.add),
    );
  }
}
