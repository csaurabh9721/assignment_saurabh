import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/timerCounterControllers/timer_counter_controllers.dart';

class CounterList extends StatefulWidget {
  final int index;

  const CounterList({
    super.key,
    required this.index,
  });

  @override
  State<CounterList> createState() => _CounterListState();
}

class _CounterListState extends State<CounterList> {
  final TimerCounterController _timerCounterController = Get.find();
  RxInt hours = 0.obs;
  RxInt minutes = 0.obs;
  RxInt seconds = 0.obs;
  Timer? _timer;
  int inputSecond = 0;

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: Container(
              height: 55,
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _timerCounterController
                          .timers[widget.index].controller,
                      keyboardType: TextInputType.number,
                      onChanged: _onChange,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Second",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: Colors.grey,
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: Colors.grey,
                    width: 0,
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: _startCountDown,
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6)),
                          color: Colors.purple,
                        ),
                        child: Text(
                          _timerCounterController
                                  .timers[widget.index].isRunning.value
                              ? 'Pause'
                              : 'Start',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(
          //   width: 8,
          // ),
          // InkWell(
          //   onTap: () {
          //     if (_timer != null) {
          //       _timer!.cancel();
          //     }
          //     _timerCounterController.removeTimer(widget.index);
          //   },
          //   child: const Icon(
          //     Icons.delete_forever_sharp,
          //     color: Colors.red,
          //     size: 30,
          //   ),
          // ),
        ],
      ),
    );
  }

  _startCountDown() {
    if (_timerCounterController
        .timers[widget.index].controller.text.isNotEmpty) {
      _timerCounterController.timers[widget.index].isRunning.value =
          !_timerCounterController.timers[widget.index].isRunning.value;
      if (_timerCounterController.timers[widget.index].isRunning.value) {
        _getFormattedTime();
      } else {
        _timer!.cancel();
      }
    }
  }

  _getFormattedTime() {
    hours.value = inputSecond ~/ 3600;
    minutes.value = (inputSecond % 3600) ~/ 60;
    seconds.value = inputSecond % 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCounterController.timers[widget.index].isRunning.value &&
          inputSecond > 0) {
        inputSecond--;
        if(inputSecond == 0){
          _timerCounterController.timers[widget.index].isRunning.value = false;
          _timerCounterController.timers[widget.index].controller.clear();
        }
        hours.value = inputSecond ~/ 3600;
        minutes.value = (inputSecond % 3600) ~/ 60;
        seconds.value = inputSecond % 60;
      }
    });
  }

  _onChange(value) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timerCounterController.timers[widget.index].isRunning.value = false;
    if (int.tryParse(value) != null) {
      int sec = int.parse(value);
      inputSecond = sec;
      hours.value = sec ~/ 3600;
      minutes.value = (sec % 3600) ~/ 60;
      seconds.value = sec % 60;
    } else {
      int sec = 0;
      inputSecond = sec;
      hours.value = sec ~/ 3600;
      minutes.value = (sec % 3600) ~/ 60;
      seconds.value = sec % 60;
    }
  }
}
