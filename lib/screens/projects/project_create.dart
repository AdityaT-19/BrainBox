import 'dart:io';

import 'package:brainbox/controllers/auth_controller.dart';
import 'package:brainbox/controllers/project_create_controller.dart';
import 'package:brainbox/models/project.dart';
import 'package:brainbox/models/user.dart';
import 'package:brainbox/screens/widgets/form_utils.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProjectCreate extends StatelessWidget {
  ProjectCreate({super.key});

  final ProjectCreateFormController projectCreateFormController =
      Get.find<ProjectCreateFormController>();
  final AuthController authController = Get.find<AuthController>();

  final imagePicker = ImagePicker();

  final _formUtils = FormUtils();

  Widget growingTextFormField(
      {String? labelText,
      String? Function(String?)? validator,
      void Function(String?)? onSaved,
      String? helperText}) {
    void addOnPressed() {
      labelText?.contains('Technology') ?? false
          ? projectCreateFormController.projectTechLen.value++
          : projectCreateFormController.projectFeatureLen.value++;
    }

    void removeOnPressed() {
      if (labelText?.contains('Technology') ?? false
          ? projectCreateFormController.projectTechLen.value > 1
          : projectCreateFormController.projectFeatureLen.value > 1) {
        labelText?.contains('Technology') ?? false
            ? projectCreateFormController.projectTechLen.value--
            : projectCreateFormController.projectFeatureLen.value--;
      }
    }

    return Row(
      children: [
        Obx(
          () => Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: labelText?.contains('Technology') ?? false
                  ? projectCreateFormController.projectTechLen.value
                  : projectCreateFormController.projectFeatureLen.value,
              itemBuilder: (context, index) {
                return _formUtils.customTextFormField(
                  labelText: labelText,
                  validator: validator,
                  onSaved: onSaved,
                  helperText: helperText,
                );
              },
            ),
          ),
        ),
        Obx(
          () {
            if (labelText?.contains('Technology') ?? false
                ? projectCreateFormController.projectTechLen.value > 1
                : projectCreateFormController.projectFeatureLen.value > 1) {
              return Column(
                children: [
                  IconButton(
                    onPressed: addOnPressed,
                    icon: Icon(
                      Icons.add,
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),
                  IconButton(
                    onPressed: removeOnPressed,
                    icon: Icon(
                      Icons.remove,
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  IconButton(
                    onPressed: addOnPressed,
                    icon: Icon(
                      Icons.add,
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),
                  IconButton(
                    onPressed: removeOnPressed,
                    icon: Icon(
                      Icons.remove,
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),
                ],
              );
            }
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Project',
          style: Get.textTheme.titleLarge!.copyWith(
            color: Get.theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Get.theme.colorScheme.primary,
        actions: [
          Obx(() => projectCreateFormController.isUploading.value
              ? Padding(
                  padding: EdgeInsets.all(Get.height * 0.01),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Get.theme.colorScheme.onPrimary,
                    ),
                  ),
                )
              : OutlinedButton.icon(
                  onPressed: () async {
                    await projectCreateFormController.submitForm();
                    if (projectCreateFormController.isUploaded.value) {
                      Get.back();
                    }
                  },
                  icon: Icon(
                    Icons.add,
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                  label: Text(
                    'Create',
                    style: Get.textTheme.labelLarge!
                        .copyWith(color: Get.theme.colorScheme.onPrimary),
                  ),
                )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: projectCreateFormController.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _formUtils.customHeader('Project Name'),
                _formUtils.customTextFormField(
                  labelText: 'Project Name',
                  validator: projectCreateFormController.validateName,
                  onSaved: projectCreateFormController.saveName,
                ),
                _formUtils.customHeader('Project Description'),
                _formUtils.customTextFormField(
                  labelText: 'Project Description',
                  validator: projectCreateFormController.validateDescription,
                  onSaved: projectCreateFormController.saveDescription,
                ),
                _formUtils.customHeader('Group'),
                Padding(
                  padding: EdgeInsets.all(Get.height * 0.01),
                  child: DropdownButtonFormField<Group>(
                    style: Get.textTheme.bodyLarge!.copyWith(
                      color: Get.theme.colorScheme.onBackground,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Group',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: authController.user.value.gids
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      projectCreateFormController.saveGroupId(value?.gid);
                    },
                  ),
                ),
                _formUtils.customHeader('Project Status'),
                CustomRadioButton(
                  elevation: 0,
                  absoluteZeroSpacing: false,
                  horizontal: true,
                  buttonLables:
                      ProjectStatus.values.map((e) => e.name).toList(),
                  buttonValues: ProjectStatus.values,
                  radioButtonValue: (p0) {
                    projectCreateFormController.projectStatus.value = p0;
                  },
                  unSelectedColor: Get.theme.colorScheme.background,
                  selectedColor: Get.theme.colorScheme.primaryContainer,
                  selectedBorderColor: Get.theme.colorScheme.primaryContainer,
                  unSelectedBorderColor: Get.theme.colorScheme.primaryContainer,
                  enableShape: true,
                  defaultSelected:
                      projectCreateFormController.projectStatus.value,
                  buttonTextStyle: ButtonTextStyle(
                    selectedColor: Get.theme.colorScheme.onPrimaryContainer,
                    unSelectedColor: Get.theme.colorScheme.onBackground,
                    textStyle: Get.textTheme.titleMedium!,
                  ),
                ),
                _formUtils.customTextFormField(
                  labelText: 'Github Link',
                  onSaved: projectCreateFormController.saveGithubLink,
                ),
                _formUtils.customHeader('Features'),
                growingTextFormField(
                  labelText: 'Feature',
                  validator: projectCreateFormController.validateFeature,
                  onSaved: projectCreateFormController.addFeature,
                ),
                _formUtils.customHeader('Technologies'),
                growingTextFormField(
                  labelText: 'Technology',
                  validator: projectCreateFormController.validateTechnology,
                  onSaved: projectCreateFormController.addTechnology,
                ),
                _formUtils.customHeader('Project Report'),
                TextButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: () async {
                      final pickedFile = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (pickedFile != null) {
                        projectCreateFormController.projectReportingFile.value =
                            File(pickedFile.files.single.path!);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(
                        Get.height * 0.01,
                      ),
                      child: Obx(() => projectCreateFormController
                                  .projectReportingFile.value ==
                              null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: Get.height * 0.05,
                                ),
                                Text(
                                  'Add Report',
                                  style: Get.textTheme.titleMedium!.copyWith(
                                      color: Get.theme.colorScheme.primary),
                                ),
                              ],
                            )
                          : Text(
                              'Report Added : ${projectCreateFormController.projectReportingFile.value!.path} files')),
                    )),
                _formUtils.customHeader('Project Images'),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: () async {
                    final pickedFiles =
                        await imagePicker.pickMultiImage(imageQuality: 50);
                    projectCreateFormController.projectImages.value =
                        pickedFiles;
                  },
                  child: Obx(
                    () => projectCreateFormController.projectImages.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(
                              Get.height * 0.01,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: Get.height * 0.05,
                                ),
                                Text(
                                  'Add Images',
                                  style: Get.textTheme.titleMedium!.copyWith(
                                      color: Get.theme.colorScheme.primary),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: Get.height * 0.2,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: projectCreateFormController
                                  .projectImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(Get.height * 0.01),
                                  child: Image.file(
                                    File(projectCreateFormController
                                        .projectImages[index].path),
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.3,
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
