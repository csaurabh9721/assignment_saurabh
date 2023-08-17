import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_test/ui/timeCounter/widgets/counter_list.dart';
import '../../controllers/timerCounterControllers/timer_counter_controllers.dart';

class TimeCounter extends StatelessWidget {
  TimeCounter({super.key});

  final TimerCounterController _timerCounterController =
      Get.put(TimerCounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Countdown List'),
      ),
      body: Obx(
        () => _timerCounterController.timers.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.all(12),
                physics: const BouncingScrollPhysics(),
                itemCount: _timerCounterController.timers.length,
                itemBuilder: (context, index) {
                  return CounterList(
                    index: index,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
              )
            : const Center(
                child: Text(
                  'Please Add Timer',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _timerCounterController.addTimer,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(25.0), // Adjust the radius as needed
          ),
          backgroundColor: Colors.purple,
          elevation: 8,
          shadowColor: Colors.black,
        ),
        child: const Text('Add Timer'),
      ),
    );
  }
}
