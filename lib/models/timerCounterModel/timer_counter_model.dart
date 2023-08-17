import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TimerData {
  TextEditingController controller;
  RxBool isRunning = false.obs;
  TimerData({required this.controller, required this.isRunning});
}
