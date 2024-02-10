import 'package:brainbox/controllers/goal_create_controller.dart';
import 'package:get/get.dart';

class GoalCreateBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalCreateController>(() => GoalCreateController());
  }
}
