import 'package:brainbox/models/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  UserController({required this.uid});

  late User user;
  final int uid;
}
