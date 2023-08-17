import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class TimerData {
  int seconds;
  bool isRunning;

  TimerData(this.seconds, this.isRunning);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown Timer List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TimerListScreen(),
    );
  }
}

class TimerListScreen extends StatefulWidget {
  const TimerListScreen({super.key});

  @override
  State<TimerListScreen> createState() => _TimerListScreenState();
}

class _TimerListScreenState extends State<TimerListScreen> {
  List<TimerData> timers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown Timer List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: timers.length,
              itemBuilder: (context, index) {
                return TimerListItem(
                  timerData: timers[index],
                  onStartPause: () {
                    setState(() {
                      timers[index].isRunning = !timers[index].isRunning;
                    });
                  },
                  onTimeChanged: (int newTime) {
                    setState(() {
                      timers[index].seconds = newTime;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                timers.add(TimerData(60, false));
              });
            },
            child: const Text('Add Timer'),
          ),
        ],
      ),
    );
  }
}

class TimerListItem extends StatefulWidget {
  final TimerData timerData;
  final Function() onStartPause;
  final Function(int) onTimeChanged;

  TimerListItem({
    required this.timerData,
    required this.onStartPause,
    required this.onTimeChanged,
  });

  @override
  _TimerListItemState createState() => _TimerListItemState();
}

class _TimerListItemState extends State<TimerListItem> {
  late int hours;
  late int minutes;
  late int seconds;
  late bool isRunning;

  late TextEditingController _controller;
   Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    hours = widget.timerData.seconds ~/ 3600;
    minutes = (widget.timerData.seconds % 3600) ~/ 60;
    seconds = widget.timerData.seconds % 60;
    isRunning = widget.timerData.isRunning;
    _controller.text = widget.timerData.seconds.toString();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isRunning && widget.timerData.seconds > 0) {
        setState(() {
          widget.timerData.seconds--;
          hours = widget.timerData.seconds ~/ 3600;
          minutes = (widget.timerData.seconds % 3600) ~/ 60;
          seconds = widget.timerData.seconds % 60;
        });
      }
    });
  }

  void _updateTime() {
    int newTime = hours * 3600 + minutes * 60 + seconds;
    widget.onTimeChanged(newTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (int.tryParse(value) != null) {
                    setState(() {
                      _controller.text = value;
                      hours = int.parse(value) ~/ 3600;
                      minutes = (int.parse(value) % 3600) ~/ 60;
                      seconds = int.parse(value) % 60;
                    });
                    _updateTime();
                  }
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text(
                '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isRunning = !isRunning;
                  });
                  widget.onStartPause();
                },
                child: Text(isRunning ? 'Pause' : 'Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer!.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }
}

