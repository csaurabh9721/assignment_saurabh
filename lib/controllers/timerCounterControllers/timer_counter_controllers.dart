import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/timerCounterModel/timer_counter_model.dart';

class TimerCounterController extends GetxController {
  RxList<TimerData> timers = <TimerData>[].obs;

  void addTimer() {
   timers.add(TimerData(
        controller: TextEditingController(),
        isRunning: false.obs));
  }
}
