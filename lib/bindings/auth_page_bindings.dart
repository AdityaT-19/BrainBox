import 'package:brainbox/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<AuthController>(
      () async {
        final controller = AuthController();
        await controller.onInit();
        return controller;
      },
    );
  }
}
