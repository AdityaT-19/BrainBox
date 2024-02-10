import 'package:brainbox/controllers/auth_controller.dart';
import 'package:get/get.dart';

class SplashPageBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(() async {
      final controller = AuthController();
      await controller.onInit();
      return controller;
    }, permanent: true);
  }
}
