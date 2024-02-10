import 'package:brainbox/controllers/goals_list_controller.dart';
import 'package:brainbox/controllers/pages_controller.dart';
import 'package:get/get.dart';

class HomePageBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put(ScreenController(), permanent: true);
    Get.put(GoalListController());
  }
}
