// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task/src/constants/colors.dart';
import 'package:task/src/models/task.dart';
import 'package:task/src/widgets/add.task.dart';

class TasksList extends StatefulWidget {
  final List<Task> tasks;
  const TasksList({Key? key, required this.tasks}) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  Color getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 10),
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: getRandomColor(),
          ),
          child: ListTile(
            title: Text(widget.tasks[index].title),
            subtitle: Text(widget.tasks[index].description),
            leading: Checkbox(
              value: widget.tasks[index].isCompleted,
              onChanged: (value) async {
                await _completeTask(widget.tasks[index]);
              },
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AddTaskPage(
                          task: widget.tasks[index],
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _updateTaskInList(widget.tasks[index], result);
                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    await _deleteTask(context, widget.tasks[index]);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

Future<void> _completeTask(Task task) async {
  final response = await Supabase.instance.client
      .from('Tasks')
      .update({'isCompleted': true}).eq('id', task.id);
  
  if (response != null && response.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error al completar la tarea'),
      ),
    );
  } else {
    setState(() {
      task.isCompleted = true;
    });
    _showTaskCompletedSnackbar(task);
  }
}

  Future<void> _deleteTask(BuildContext context, Task task) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Estás seguro de que quieres eliminar esta tarea?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (result != null && result) {
      final response = await Supabase.instance.client
          .from('Tasks')
          .delete()
          .eq('id', task.id);
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea eliminada exitosamente'),
          ),
        );
        setState(() {
          widget.tasks.remove(task);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al eliminar la tarea'),
          ),
        );
      }
    }
  }

Future<void> _updateTaskInList(Task task, List<Object?> result) async {
  if (result.length >= 2 && result[0] is String && result[1] is String) {
    setState(() {
      task.title = result[0] as String;
      task.description = result[1] as String;
    });

    final response = await Supabase.instance.client
        .from('Tasks')
        .update({'title': task.title, 'description': task.description})
        .eq('id', task.id);

    if (response!= null && response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al actualizar la tarea en Supabase'),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error: Resultado no válido para la actualización de la tarea'),
      ),
    );
  }
}

  void _showTaskCompletedSnackbar(Task task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea "${task.title}" completada'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
