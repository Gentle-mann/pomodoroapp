import 'dart:async';

import 'package:flutter/material.dart';

Widget buildTaskContainer(title) {
  return Container(
    height: 60,
    padding: const EdgeInsets.only(left: 16.0),
    margin: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.deepPurpleAccent.shade100,
      boxShadow: [
        BoxShadow(
          color: Colors.deepPurpleAccent.shade100,
          blurRadius: 12.0,
          blurStyle: BlurStyle.outer,
        ),
      ],
      borderRadius: BorderRadius.circular(40.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 8,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildPauseButton(VoidCallback stopSession) {
  return Container(
    height: 80,
    width: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.0),
      boxShadow: [
        BoxShadow(
          color: Colors.deepPurpleAccent.shade100,
          blurRadius: 6.0,
          spreadRadius: 1.0,
          offset: const Offset(0.0, 4.0),
        ),
      ],
    ),
    child: Card(
      color: Colors.deepPurpleAccent,
      shadowColor: Colors.deepPurpleAccent.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: IconButton(
        onPressed: stopSession,
        icon: const Icon(
          Icons.pause_outlined,
          color: Colors.white,
          size: 48,
        ),
      ),
    ),
  );
}

Widget buildRemainingSessionsText(int sessions) {
  return Text(
    'Remaining sessions: $sessions',
    style: const TextStyle(
      fontSize: 20,
    ),
  );
}

Widget buildContinueButton(
  bool isOnBreak,
  VoidCallback startSession,
) {
  return Container(
    height: 80,
    width: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.0),
      boxShadow: [
        BoxShadow(
          color: Colors.deepPurpleAccent.shade100,
          blurRadius: 6.0,
          spreadRadius: 1.0,
          offset: const Offset(0.0, 4.0),
        ),
      ],
    ),
    child: Card(
      color: Colors.deepPurpleAccent,
      shadowColor: Colors.deepPurpleAccent.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: IconButton(
        onPressed: startSession,
        icon:
            const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 48),
      ),
    ),
  );
}

Widget buildStopButton(VoidCallback restartTimer) {
  return Container(
    height: 80,
    width: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.0),
      boxShadow: [
        BoxShadow(
          color: Colors.deepPurpleAccent.shade100,
          blurRadius: 6.0,
          spreadRadius: 1.0,
          offset: const Offset(0.0, 4.0),
        ),
      ],
    ),
    child: Card(
      color: Colors.deepPurpleAccent,
      shadowColor: Colors.deepPurpleAccent.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: IconButton(
        onPressed: restartTimer,
        icon: const Icon(
          Icons.stop_rounded,
          color: Colors.white,
          size: 48,
        ),
      ),
    ),
  );
}

Widget buildTimeText(
    {required bool isOnBreak,
    required int focus,
    Timer? timer,
    required chillTime}) {
  final focusSeconds = focus.remainder(60).toString().padLeft(2, '0');
  final focusMinutes = timer == null ? focus ~/ 60 : focus ~/ 60;

  final chillSeconds = chillTime.remainder(60).toString().padLeft(2, '0');
  final chillMinutes = timer == null ? chillTime ~/ 60 : chillTime ~/ 60;
  return Text(
    isOnBreak ? '$chillMinutes :$chillSeconds' : '$focusMinutes :$focusSeconds',
    style: const TextStyle(
      color: Colors.deepPurpleAccent,
      fontSize: 80,
      fontWeight: FontWeight.w100,
    ),
  );
}

Widget buildProgressIndicator({
  required bool isOnBreak,
  required int focus,
  required int chillTime,
  required int focusTime,
  required int breakTime,
}) {
  return CircularProgressIndicator(
    value: !isOnBreak ? focus / (focusTime * 60) : chillTime / (breakTime * 60),
    strokeWidth: 4,
    valueColor: const AlwaysStoppedAnimation(Colors.white),
    backgroundColor: Colors.deepPurpleAccent,
    color: Colors.white,
  );
}

Widget buildTimeStack({
  required int focus,
  required int chillTime,
  required int focusTime,
  required int breakTime,
  required bool isOnBreak,
  Timer? timer,
}) {
  return Container(
    height: 240,
    width: 240,
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(120.0),
      boxShadow: [
        BoxShadow(
          blurRadius: 16,
          color: Colors.deepPurpleAccent.shade100,
          blurStyle: BlurStyle.outer,
        ),
      ],
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        buildProgressIndicator(
            isOnBreak: isOnBreak,
            focus: focus,
            chillTime: chillTime,
            focusTime: focusTime,
            breakTime: breakTime),
        Center(
          child: buildTimeText(
            isOnBreak: isOnBreak,
            focus: focus,
            chillTime: chillTime,
          ),
        ),
      ],
    ),
  );
}

Widget buildSessionIndicator(isOnBreak) {
  return Text(
    isOnBreak ? 'Break...' : 'Focus...',
    style: const TextStyle(
      fontSize: 24,
      fontStyle: FontStyle.italic,
    ),
  );
}
