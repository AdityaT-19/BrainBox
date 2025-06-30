import 'dart:io';

import 'package:brainbox/controllers/auth_controller.dart';
import 'package:brainbox/controllers/project_update_controller.dart';
import 'package:brainbox/models/project.dart';
import 'package:brainbox/models/user.dart';
import 'package:brainbox/screens/widgets/form_utils.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProjectUpdate extends StatelessWidget {
  ProjectUpdate({super.key, required this.project});
  final Project project;

  final ProjectUpdateFormController projectUpdateFormController = Get.find();
  final AuthController authController = Get.find<AuthController>();

  final imagePicker = ImagePicker();

  final _formUtils = FormUtils();

  void addOnPressedTech() {
    projectUpdateFormController.projectTechnologies.add('');
  }

  void removeOnPressedTech() {
    if (projectUpdateFormController.projectTechnologies.length > 1) {
      projectUpdateFormController.projectTechnologies.removeLast();
    }
  }

  void addOnPressedFeature() {
    projectUpdateFormController.projectFeatures.add('');
  }

  void removeOnPressedFeature() {
    if (projectUpdateFormController.projectFeatures.length > 1) {
      projectUpdateFormController.projectFeatures.removeLast();
    }
  }

  String? getInitialTechVal(int index) {
    if (projectUpdateFormController.projectTechnologies.length > index &&
        projectUpdateFormController.projectTechnologies[index].isNotEmpty) {
      return projectUpdateFormController.projectTechnologies[index];
    }
    return null;
  }

  String? getInitialFeatureVal(int index) {
    if (projectUpdateFormController.projectFeatures.length > index &&
        projectUpdateFormController.projectFeatures[index].isNotEmpty) {
      return projectUpdateFormController.projectFeatures[index];
    }
    return null;
  }

  Widget growingTextFormField(
      {String? labelText,
      String? Function(String?)? validator,
      void Function(String?, int)? onSaved,
      String? helperText}) {
    List<Widget> buttons = [
      IconButton(
        onPressed: labelText?.contains('Technology') ?? false
            ? addOnPressedTech
            : addOnPressedFeature,
        icon: Icon(
          Icons.add,
          color: Get.theme.colorScheme.secondary,
        ),
      ),
      IconButton(
        onPressed: labelText?.contains('Technology') ?? false
            ? removeOnPressedTech
            : removeOnPressedFeature,
        icon: Icon(
          Icons.remove,
          color: Get.theme.colorScheme.secondary,
        ),
      ),
    ];
    return Row(
      children: [
        Obx(
          () => Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: labelText?.contains('Technology') ?? false
                  ? projectUpdateFormController.projectTechnologies.length
                  : projectUpdateFormController.projectFeatures.length,
              itemBuilder: (context, index) {
                return _formUtils.customTextFormField(
                  labelText: labelText,
                  validator: validator,
                  onSaved: (p0) {
                    onSaved!(p0, index);
                  },
                  helperText: helperText,
                  initialValue: labelText?.contains('Technology') ?? false
                      ? getInitialTechVal(index)
                      : getInitialFeatureVal(index),
                );
              },
            ),
          ),
        ),
        Obx(
          () {
            if (labelText?.contains('Technology') ?? false
                ? projectUpdateFormController.projectTechnologies.length > 1
                : projectUpdateFormController.projectFeatures.length > 1) {
              return Column(
                children: buttons,
              );
            } else {
              return Row(
                children: buttons,
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
          Obx(
            () => projectUpdateFormController.isUploading.value
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
                      await projectUpdateFormController.submitForm();
                      if (projectUpdateFormController.isUploaded.value) {
                        Get.back();
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                    label: Text(
                      'Update',
                      style: Get.textTheme.labelLarge!
                          .copyWith(color: Get.theme.colorScheme.onPrimary),
                    ),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: projectUpdateFormController.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _formUtils.customHeader('Project Name'),
                _formUtils.customTextFormField(
                  labelText: 'Project Name',
                  validator: projectUpdateFormController.validateName,
                  onSaved: projectUpdateFormController.saveName,
                  initialValue: project.name.value,
                ),
                _formUtils.customHeader('Project Description'),
                _formUtils.customTextFormField(
                  labelText: 'Project Description',
                  validator: projectUpdateFormController.validateDescription,
                  onSaved: projectUpdateFormController.saveDescription,
                  initialValue: project.description.value,
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
                      projectUpdateFormController.saveGroupId(value?.gid);
                    },
                    value: authController.user.value.gids.firstWhereOrNull(
                        (element) => project.groupId.value == element),
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
                    projectUpdateFormController.projectStatus.value = p0;
                  },
                  unSelectedColor: Get.theme.colorScheme.background,
                  selectedColor: Get.theme.colorScheme.primaryContainer,
                  selectedBorderColor: Get.theme.colorScheme.primaryContainer,
                  unSelectedBorderColor: Get.theme.colorScheme.primaryContainer,
                  enableShape: true,
                  defaultSelected: project.status.value,
                  buttonTextStyle: ButtonTextStyle(
                    selectedColor: Get.theme.colorScheme.onPrimaryContainer,
                    unSelectedColor: Get.theme.colorScheme.onBackground,
                    textStyle: Get.textTheme.titleMedium!,
                  ),
                ),
                _formUtils.customTextFormField(
                  labelText: 'Github Link',
                  onSaved: projectUpdateFormController.saveGithubLink,
                  initialValue: project.githubLink.value,
                ),
                _formUtils.customHeader('Features'),
                growingTextFormField(
                  labelText: 'Feature',
                  validator: projectUpdateFormController.validateFeature,
                  onSaved: projectUpdateFormController.addFeature,
                ),
                _formUtils.customHeader('Technologies'),
                growingTextFormField(
                  labelText: 'Technology',
                  validator: projectUpdateFormController.validateTechnology,
                  onSaved: projectUpdateFormController.addTechnology,
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
                        projectUpdateFormController.projectReportingFile.value =
                            File(pickedFile.files.single.path!);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(
                        Get.height * 0.01,
                      ),
                      child: Obx(() => projectUpdateFormController
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
                                  'Update Report',
                                  style: Get.textTheme.titleMedium!.copyWith(
                                      color: Get.theme.colorScheme.primary),
                                ),
                              ],
                            )
                          : Text(
                              'Report Added : ${projectUpdateFormController.projectReportingFile.value!.path} files')),
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
                    projectUpdateFormController.projectImages.value =
                        pickedFiles;
                  },
                  child: Obx(
                    () => projectUpdateFormController.projectImages.isEmpty
                        ? project.imageLinks.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(Get.height * 0.01),
                                    child: Image.network(
                                      project.imageLinks[index],
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.3,
                                    ),
                                  );
                                },
                                itemCount: project.imageLinks.length,
                                shrinkWrap: true,
                              )
                            : Padding(
                                padding: EdgeInsets.all(
                                  Get.height * 0.01,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      size: Get.height * 0.05,
                                    ),
                                    Text(
                                      'Add Images',
                                      style: Get.textTheme.titleMedium!
                                          .copyWith(
                                              color: Get
                                                  .theme.colorScheme.primary),
                                    ),
                                  ],
                                ),
                              )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: projectUpdateFormController
                                .projectImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(Get.height * 0.01),
                                child: Image.file(
                                  File(projectUpdateFormController
                                      .projectImages[index].path),
                                  height: Get.height * 0.2,
                                  width: Get.width * 0.3,
                                ),
                              );
                            },
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
