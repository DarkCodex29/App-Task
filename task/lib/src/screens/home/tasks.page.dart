// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task/src/widgets/add.task.dart';
import 'package:task/src/widgets/tasks.list.dart';
import '../../models/task.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  late Future<List<Task>> _future;
  @override
  void initState() {
    super.initState();
    _future = _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[50],
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
  return FutureBuilder<List<Task>>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(
          child: Text('No hay tareas'),
        );
      } else {
        return TasksList(tasks: snapshot.data!);
      }
    },
  );
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
          final response = await Supabase.instance.client.from('Tasks').insert([
            {
              'title': result[0],
              'description': result[1],
              'isCompleted': false,
            }
          ]);
        if (response != null && response.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al agregar la tarea'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tarea agregada exitosamente'),
            ),
          );
          setState(() {
            _future = _fetchTasks();
          });
        }
      }
    },
      elevation: 10,
      child: const Icon(Icons.add),
    );
  }

  Future<List<Task>> _fetchTasks() async {
    final response = await Supabase.instance.client.from('Tasks').select("*");
    final List<Map<String, dynamic>> data = response;
    
    final tasks = data.map((item) => Task(
      id: item['id'] as int,
      title: item['title'] as String,
      description: item['description'] as String,
      isCompleted: item['isCompleted'] == null ? false : item['isCompleted'] as bool,
    )).toList();

    return tasks;
  }
}
