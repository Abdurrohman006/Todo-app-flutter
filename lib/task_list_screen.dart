import 'package:awesome_notifications/awesome_notifications.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:todo_app/add_task_screen.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat("MMM dd, yyyy, hh:mm");

  Widget _buildItem(Task task) {
    return Container(
      color: Color.fromARGB(45, 0, 0, 0),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTaskScreen(
              updateTaskList: _updateTaskList,
              task: task,
            ),
          ),
        ),
        title: Text(
          task.title!,
          style: TextStyle(
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough),
        ),
        subtitle: Text(
          _dateFormat.format(task.date),
          style: TextStyle(
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough),
        ),
        trailing: Checkbox(
          value: task.status == 0 ? false : true,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (bool? value) {
            if (value != null) {
              task.status = value ? 1 : 0;
            }
            DatabaseHelper.instance.updateTask(task);
            _updateTaskList();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Allow notification'),
          content: const Text('This app wants to show notification'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Dont allow",
                style: TextStyle(color: Colors.green, fontSize: 10),
              ),
            ),
            TextButton(
              onPressed: () {
                AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((value) => Navigator.pop(context));
              },
              child: const Text(
                "allow",
                style: TextStyle(color: Colors.green, fontSize: 10),
              ),
            ),
          ],
        ),
      );
    });

    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    AddTaskScreen(updateTaskList: _updateTaskList))),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _taskList,
          builder: (context, AsyncSnapshot snapshot) {
            return ListView.builder(
                itemCount: snapshot.data != null ? snapshot.data.length + 1 : 0,
                itemBuilder: (BuildContext context, int index) {
                  final int completedTaskCount = snapshot.data
                      .where((Task task) => task.status == 1)
                      .toList()
                      .length;

                  if (index == 0) {
                    return Container(
                      child: Row(
                        children: [
                          const Text(
                            "My Task",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "$completedTaskCount/${snapshot.data.length}",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return _buildItem(snapshot.data[index - 1]);
                  }
                });
          }),
    );
  }
}
