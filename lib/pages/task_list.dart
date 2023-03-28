import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/pages/home.dart';
import 'package:provider/provider.dart';

import '../classes/models/task.dart';
import '../db/tasks_database.dart';
import '../provider/task_provider.dart';
import 'add_edit_task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late List<Task> tasks;

  Future<void> createTask(Task task) async {
    await TasksDatabase.instance.create(task);
  }

  Future<void> updateTask(task) async {
    await TasksDatabase.instance.update(task);
  }

  Future<void> addOrEditTask({
    required bool add,
    required int index,
    required Task task,
  }) async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    TaskEdit taskEdit = TaskEdit(task: task, action: '');
    taskEdit = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return AddOrEditTask(add: add, index: index, taskEdit: taskEdit);
      }),
    );
    switch (taskEdit.action) {
      case 'Save':
        if (add) {
          provider.createTask(taskEdit.task);
        } else {
          provider.updateTask(taskEdit.task);
        }
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  Future<void> deleteTask(int taskId) async {
    await TasksDatabase.instance.delete(taskId);
    print('deleted task with id $taskId');
  }

  Future<List<Task>> loadTasks() async {
    tasks = await TasksDatabase.instance.readAllTask();
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List'), actions: [
        IconButton(
          onPressed: () {
            addOrEditTask(
              add: true,
              index: -1,
              task: Task(
                loops: '',
                title: '',
                focusTime: 0,
                breakTime: 0,
                createdTime: '',
              ),
            );
          },
          icon: const Icon(
            Icons.add_rounded,
            color: Colors.deepPurpleAccent,
            size: 32.0,
          ),
        ),
      ]),
      body: buildFutureBuilder(),
    );
  }

  FutureBuilder<List<dynamic>> buildFutureBuilder() {
    final provider = Provider.of<TaskProvider>(context);
    return FutureBuilder(
      future: provider.getAllTasks,
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return !snapshot.hasData
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        gradient: const LinearGradient(
                          colors: [Colors.deepPurple, Color(0xFF5A4A78)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF5A4A78),
                            spreadRadius: 1,
                            blurRadius: 4,
                          ),
                        ]),
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${snapshot.data[index].focusTime}',
                            style: const TextStyle(
                              fontSize: 28.0,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            '${snapshot.data[index].breakTime}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat.yMMMEd().format(
                              DateTime.parse(snapshot.data[index].createdTime),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final provider = Provider.of<TaskProvider>(
                                context,
                                listen: false,
                              );
                              provider.deleteTask(snapshot.data[index].id);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return Home(
                                  task: snapshot.data[index],
                                );
                              },
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.green,
                          size: 40.0,
                        ),
                      ),
                      title: Text(
                        snapshot.data[index].title,
                        style: const TextStyle(
                          color: Colors.white,
                          //fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () {
                        addOrEditTask(
                          add: false,
                          index: index,
                          task: snapshot.data[index],
                        );
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}
