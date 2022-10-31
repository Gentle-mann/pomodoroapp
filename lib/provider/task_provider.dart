import 'package:flutter/foundation.dart';

import '../classes/models/task.dart';
import '../db/tasks_database.dart';

class TaskProvider extends ChangeNotifier {
  Future<List<Task>> _getAllTasks() async {
    final List<Task> tasks = await TasksDatabase.instance.readAllTask();
    return tasks;
  }

  Future<List<Task>> get getAllTasks {
    return _getAllTasks();
  }

  Future<void> createTask(task) async {
    await TasksDatabase.instance.create(task);
    print('task created');
    notifyListeners();
  }

  Future<void> updateTask(task) async {
    await TasksDatabase.instance.update(task);
    print('task updated');
    notifyListeners();
  }

  Future<void> deleteTask(int taskId) async {
    await TasksDatabase.instance.delete(taskId);
    print('deleted task with id $taskId');
    notifyListeners();
  }
}
