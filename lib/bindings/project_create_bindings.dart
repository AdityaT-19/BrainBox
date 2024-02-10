import 'package:brainbox/controllers/project_create_controller.dart';
import 'package:get/get.dart';

class ProjectCreateBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ProjectCreateFormController>(ProjectCreateFormController());
  }
}
