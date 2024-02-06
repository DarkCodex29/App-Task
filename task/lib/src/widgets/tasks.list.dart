import 'dart:math';
import 'package:flutter/material.dart';
import 'package:task/src/constants/colors.dart';
import 'package:task/src/models/task.dart';
import 'package:task/src/widgets/add.task.dart';

// ignore: must_be_immutable
class TasksList extends StatefulWidget {
  List<Task> tasks = [];
  TasksList({super.key, required this.tasks});

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
                  if (widget.tasks[index].isCompleted) {
                    _showCompletedAlertDialog(
                        'La tarea "${widget.tasks[index].title}" ya está completa.');
                  } else {
                    final result =
                        await _showConfirmTask(context, widget.tasks[index]);
                    if (result) {
                      _completeTask(widget.tasks[index]);
                    }
                  }
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
                      final result =
                          await _showDeleteTask(context, widget.tasks[index]);
                      if (result) {
                        _deleteTask(widget.tasks[index]);
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              )),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  void _completeTask(Task task) {
    setState(() {
      task.isCompleted = true;
    });
    _showTaskCompletedSnackbar(task);
  }

  void _deleteTask(Task task) {
    setState(() {
      widget.tasks.remove(task);
    });
  }

  void _updateTaskInList(Task task, List<String> result) {
    setState(() {
      task.title = result[0];
      task.description = result[1];
    });
  }

  Future<dynamic> _showDeleteTask(BuildContext context, Task task) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar'),
            content:
                const Text('¿Estás seguro de que quieres eliminar esta tarea?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Eliminar'))
            ],
          );
        });
  }

  Future<dynamic> _showConfirmTask(BuildContext context, Task task) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar'),
            content: Text('¿Has completado la tarea "${task.title}"?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Sí, completada'))
            ],
          );
        });
  }

  void _showTaskCompletedSnackbar(Task task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea "${task.title}" completada'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCompletedAlertDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Tarea completada'),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK')),
            ],
          );
        });
  }
}
