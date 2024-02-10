import 'package:brainbox/controllers/goal_create_controller.dart';
import 'package:brainbox/models/goal.dart';
import 'package:brainbox/screens/widgets/form_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class GoalCreate extends StatelessWidget {
  GoalCreate({super.key});
  final GoalCreateController _goalCreateController =
      Get.find<GoalCreateController>();

  final _formUtils = FormUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Goal',
          style: Get.textTheme.titleLarge!.copyWith(
            color: Get.theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Get.theme.colorScheme.primary,
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              _goalCreateController.submit();
            },
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _goalCreateController.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _formUtils.customHeader('Goal Details'),
              _formUtils.customTextFormField(
                labelText: 'Goal Title',
                validator: _goalCreateController.validateGoalName,
                onSaved: _goalCreateController.saveGoalName,
              ),
              _formUtils.customHeader('Goal Description'),
              _formUtils.customTextFormField(
                labelText: 'Goal Description',
                validator: _goalCreateController.validateGoalDescription,
                onSaved: _goalCreateController.saveGoalDescription,
              ),
              _formUtils.customHeader('Due Date'),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.01),
                child: TextButton.icon(
                  onPressed: () async {
                    final date = await showOmniDateTimePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                    );
                    _goalCreateController.saveDueDate(date);
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Obx(
                    () => Text(
                      _goalCreateController.dueDate.value == null
                          ? 'Select Due Date'
                          : DateFormat.yMMMd()
                              .add_jm()
                              .format(_goalCreateController.dueDate.value!),
                    ),
                  ),
                ),
              ),
              _formUtils.customHeader('Recurrence'),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.01),
                child: DropdownButtonFormField(
                  value: _goalCreateController.recurrence.value,
                  style: Get.textTheme.bodyLarge!.copyWith(
                    color: Get.theme.colorScheme.onBackground,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Recurrence',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: Recurrence.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name.capitalizeFirst!),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    _goalCreateController.saveRecurrence(value as Recurrence);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
