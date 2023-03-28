import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/models/task.dart';

class AddOrEditTask extends StatefulWidget {
  const AddOrEditTask(
      {Key? key,
      required this.add,
      required this.index,
      required this.taskEdit})
      : super(key: key);
  final bool add;
  final int index;
  final TaskEdit taskEdit;

  @override
  State<AddOrEditTask> createState() => _AddOrEditTaskState();
}

class _AddOrEditTaskState extends State<AddOrEditTask> {
  final titleController = TextEditingController();
  final titleFocus = FocusNode();
  late TaskEdit _taskEdit;
  late Duration focusDuration;
  late Duration breakDuration;
  late int durationFocus;
  late int durationBreak;
  late DateTime createdDate;
  late TextEditingController loopController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskEdit = TaskEdit(task: widget.taskEdit.task, action: 'Cancel');
    _taskEdit.task = widget.taskEdit.task;

    if (widget.add) {
      titleController.text = '';
      loopController.text = '';
      durationFocus = 0;
      durationBreak = 0;
      createdDate = DateTime.now();
    } else {
      titleController.text = _taskEdit.task.title;
      loopController.text = _taskEdit.task.loops;
      durationFocus = _taskEdit.task.focusTime;
      durationBreak = _taskEdit.task.breakTime;
      createdDate = DateTime.parse(_taskEdit.task.createdTime);
    }
    focusDuration = Duration(minutes: durationFocus);
    breakDuration = Duration(minutes: durationBreak);
  }

  @override
  void dispose() {
    titleController.dispose();
    loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _taskEdit.action = 'Cancel';
            Navigator.pop(context, _taskEdit);
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.purple,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text('Add Task'),
        actions: [
          TextButton(
            onPressed: () {
              _taskEdit.action = 'Save';
              final int? id = _taskEdit.task.id;
              final Task task = Task(
                loops: loopController.text,
                id: id,
                title: titleController.text,
                focusTime: focusDuration.inMinutes,
                breakTime: breakDuration.inMinutes,
                createdTime: DateTime.now().toIso8601String(),
              );
              _taskEdit.task = task;
              Navigator.of(context).pop(_taskEdit);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              buildTaskColumn(),
            ])),
      ),
    );
  }

  Column buildTaskColumn() {
    return Column(
      children: [
        buildTitleField(),
        const SizedBox(height: 16.0),
        buildFocusTimeCard(),
        buildBreakTimeCard(),
        const SizedBox(height: 12.0),
        buildLoopsField(),
      ],
    );
  }

  Widget buildTitleField() {
    return TextFormField(
      controller: titleController,
      focusNode: titleFocus,
      decoration: const InputDecoration(
          icon: Icon(Icons.note_alt_rounded),
          labelText: 'Enter task title',
          //errorText: 'Title cannot be empty',
          border: OutlineInputBorder()),
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      style: const TextStyle(
        fontSize: 20.0,
      ),
      autofocus: false,
      //validator: ,
    );
  }

  Widget buildLoopsField() {
    return TextFormField(
      controller: loopController,
      decoration: const InputDecoration(
          icon: Icon(Icons.repeat_on_rounded),
          labelText: 'Enter no. of sessions',
          //errorText: 'Field cannot be empty',
          border: OutlineInputBorder()),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        fontSize: 15.0,
      ),
      //validator: ,
    );
  }

  Widget buildFocusTimeCard() {
    return InkWell(
      onTap: () {
        showTimerPicker();
      },
      child: SizedBox(
        height: 64.0,
        child: Card(
          margin: const EdgeInsets.all(6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: const [
                  Text(
                    'Focus Time',
                  ),
                ],
              ),
              Row(
                children: [
                  Text('${focusDuration.inMinutes} min'),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 24.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBreakTimeCard() {
    return InkWell(
      onTap: () {
        showBreakTimerPicker(breakDuration);
      },
      child: SizedBox(
        height: 64.0,
        child: Card(
          margin: const EdgeInsets.all(6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: const [
                  Text(
                    'Break Time',
                  ),
                ],
              ),
              Row(
                children: [
                  Text('${breakDuration.inMinutes} min'),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 24.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addTaskBox() {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 64,
        width: 50,
        child: Card(
          margin: const EdgeInsets.only(top: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_rounded),
              SizedBox(width: 12.0),
              Text('Add Task'),
            ],
          ),
        ),
      ),
    );
  }

  void showTimerPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
          ),
          child: CupertinoTimerPicker(
            initialTimerDuration: focusDuration,
            onTimerDurationChanged: (newDuration) {
              setState(
                () {
                  focusDuration = newDuration;
                  print('duration changed');
                },
              );
            },
            mode: CupertinoTimerPickerMode.hm,
          ),
        );
      },
    );
  }

  void showBreakTimerPicker(Duration duration) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
          ),
          child: CupertinoTimerPicker(
            initialTimerDuration: duration,
            onTimerDurationChanged: (newDuration) {
              setState(
                () {
                  breakDuration = newDuration;
                },
              );
            },
            mode: CupertinoTimerPickerMode.hm,
          ),
        );
      },
    );
  }
}
