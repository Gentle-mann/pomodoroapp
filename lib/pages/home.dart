import 'package:flutter/material.dart';
import 'package:pomodoro/pages/task_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Pomodoro',
          style: TextStyle(
            fontSize: 24.0,
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
            //fit: FlexFit.tight,
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildTaskContainer(),
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
                  child: buildTimeStack(),
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
                buildPauseButton(),
                const SizedBox(width: 16.0),
                buildContinueButton(),
                const SizedBox(width: 16.0),
                buildStopButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTaskContainer() {
    return Container(
      padding: const EdgeInsets.only(left: 16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.shade100,
            blurRadius: 12.0,
            //spreadRadius: 8.0,
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
            const Flexible(
              flex: 4,
              child: Text(
                'Task: Example Task',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPauseButton() {
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
        child: const Icon(Icons.pause_outlined, color: Colors.white, size: 48),
      ),
    );
  }

  Widget buildContinueButton() {
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
        child:
            const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 48),
      ),
    );
  }

  Widget buildStopButton() {
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
        child: const Icon(Icons.stop_rounded, color: Colors.white, size: 48),
      ),
    );
  }

  Widget buildTimeText() {
    return const Text(
      '00:00',
      style: TextStyle(
        color: Colors.deepPurpleAccent,
        fontSize: 80,
        fontWeight: FontWeight.w100,
      ),
    );
  }

  Widget buildProgressIndicator() {
    return const CircularProgressIndicator(
      value: 0.4,
      strokeWidth: 4,
      valueColor: AlwaysStoppedAnimation(Colors.white),
      backgroundColor: Colors.deepPurpleAccent,
      color: Colors.white,
    );
  }

  Widget buildTimeStack() {
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
          buildProgressIndicator(),
          Center(
            child: buildTimeText(),
          ),
        ],
      ),
    );
  }
}
