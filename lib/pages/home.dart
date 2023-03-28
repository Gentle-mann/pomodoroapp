import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro/pages/task_list.dart';
import 'widgets.dart';
import '../classes/models/task.dart';
import '../services/notification_service.dart';

class Home extends StatefulWidget {
  final Task task;
  const Home({Key? key, required this.task}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? timer;
  late int focus;
  late int chillTime;
  late int sessions;
  bool isOnBreak = false;
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    focus = widget.task.focusTime * 60;
    chillTime = widget.task.breakTime * 60;
    sessions = int.parse(widget.task.loops);

    notificationService.initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = timer == null ? false : timer!.isActive;
    final isComplete = sessions == 0 ? true : false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: const Text(
          'Multiple Session Pomodoro',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: SizedBox(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const TaskListPage();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.list_rounded,
              size: 32.0,
              color: Colors.deepPurpleAccent,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings_rounded,
              size: 24.0,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      buildTaskContainer(widget.task.title),
                      const SizedBox(height: 12.0),
                      buildSessionIndicator(isOnBreak),
                      buildRemainingSessionsText(sessions),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Flexible(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: buildTimeStack(
                    focus: focus,
                    chillTime: chillTime,
                    focusTime: widget.task.focusTime,
                    breakTime: widget.task.breakTime,
                    isOnBreak: isOnBreak,
                    timer: timer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                !isRunning || isComplete
                    ? buildContinueButton(isOnBreak, startSession)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildPauseButton(stopSession),
                          const SizedBox(width: 24.0),
                          buildStopButton(restartTimer),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void resetTimer() {
    setState(() {
      focus = widget.task.focusTime * 60;
      chillTime = widget.task.breakTime * 60;
      isOnBreak = false;
    });
  }

  void restartTimer() {
    setState(() {
      stopSession(reset: true);

      sessions = int.parse(widget.task.loops);
    });
  }

  void stopSession({bool reset = false}) {
    setState(() {
      timer?.cancel();
    });

    if (reset) {
      resetTimer();
    }
  }

  void startBreak() {
    chillTime--;
  }

  void startFocus() {
    focus--;
  }

  void startSession({bool reset = false}) {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (reset) {
        resetTimer();
      }
      setState(() {
        if (focus > 0 && sessions > 0) {
          startFocus();
        } else if (focus == 0) {
          showFocusNotification();
          isOnBreak = true;
          focus = -1;
        } else if (chillTime > 0 && sessions > 0) {
          startBreak();
        } else if (chillTime == 0) {
          showBreakNotification();
          sessions--;
          stopSession(reset: true);
          startSession();
        } else {
          restartTimer();
        }
      });
    });
  }

  Future<void> showFocusNotification() async {
    await notificationService.showFocusNotification(
      id: 0,
      title: 'Progress!!',
      body: 'Focus Time over',
    );
  }

  Future<void> showBreakNotification() async {
    await notificationService.showBreakNotification(
      id: 0,
      title: 'Progress!!',
      body: 'Break Time over',
    );
  }
}
