import 'package:brainbox/controllers/auth_controller.dart';
import 'package:brainbox/controllers/goals_list_controller.dart';
import 'package:brainbox/models/goal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GoalCreateController extends GetxController {
  RxnString goalName = RxnString();
  RxnString goalDescription = RxnString();
  Rxn<DateTime> dueDate = Rxn<DateTime>();
  Rxn<Recurrence> recurrence = Rxn<Recurrence>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _authController = Get.find<AuthController>();
  final _goalListController = Get.find<GoalListController>();

  String? validateGoalName(String? value) {
    if (GetUtils.isNullOrBlank(value) ?? false) {
      return 'Goal name is required';
    }
    return null;
  }

  void saveGoalName(String? value) {
    goalName.value = value!;
  }

  String? validateGoalDescription(String? value) {
    if (GetUtils.isNullOrBlank(value) ?? false) {
      return 'Goal description is required';
    }
    return null;
  }

  void saveGoalDescription(String? value) {
    goalDescription.value = value!;
  }

  void saveDueDate(DateTime? value) {
    dueDate.value = value;
  }

  void saveRecurrence(Recurrence? value) {
    recurrence.value = value;
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (dueDate.value != null && recurrence.value != null) {
        final goal = Goal(
          name: goalName.value!,
          description: goalDescription.value!,
          dueDate: dueDate.value!,
          recurrence: recurrence.value!,
          createdDate: DateTime.now(),
          goalId: const Uuid().v4().substring(0, 5),
          isCompleted: RxBool(false),
          isRecurring: recurrence.value! != Recurrence.none,
          userId: _authController.user.value.uid,
        );

        _goalListController.tempAddGoal(goal);
      } else {
        Get.snackbar(
          'Error',
          'Please select due date and recurrence',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
