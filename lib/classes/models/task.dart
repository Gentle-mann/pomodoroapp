const String taskTable = 'tasks';

class TaskFields {
  static const List<String> values = [
    id,
    title,
    focusTime,
    breakTime,
    createdTime,
    loops,
  ];
  static const String id = '_id';
  static const String title = 'title';
  static const String focusTime = 'focusTime';
  static const String breakTime = 'breakTime';
  static const String createdTime = 'createdTime';
  static const String loops = 'loops';
}

class Task {
  final int? id;
  final String title;
  final int focusTime;
  final int breakTime;
  final String createdTime;
  final String loops;

  Task({
    this.id,
    required this.title,
    required this.focusTime,
    required this.breakTime,
    required this.createdTime,
    required this.loops,
  });

  Task copy({
    int? id,
    String? title,
    int? focusTime,
    int? breakTime,
    String? createdTime,
    String? loops,
  }) {
    return Task(
      title: title ?? this.title,
      focusTime: focusTime ?? this.focusTime,
      breakTime: breakTime ?? this.breakTime,
      createdTime: createdTime ?? this.createdTime,
      loops: loops ?? this.loops,
    );
  }

  static Task fromJson(Map<String, Object?> json) {
    return Task(
      id: json[TaskFields.id] as int?,
      title: json[TaskFields.title] as String,
      focusTime: json[TaskFields.focusTime] as int,
      breakTime: json[TaskFields.breakTime] as int,
      createdTime: json[TaskFields.createdTime] as String,
      loops: json[TaskFields.loops] as String,
    );
  }

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.breakTime: breakTime,
        TaskFields.focusTime: focusTime,
        TaskFields.createdTime: createdTime,
        TaskFields.loops: loops,
      };
}

class TaskEdit {
  Task task;
  String action;

  TaskEdit({required this.task, required this.action});
}
