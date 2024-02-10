import 'dart:io';

import 'package:brainbox/models/project.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

class ProjectCreateFormController extends GetxController {
  RxnString projectName = RxnString();
  RxBool isUploaded = false.obs;
  RxnString projectDescription = RxnString();
  RxList<String> projectFeatures = <String>[].obs;
  RxList<String> projectTechnologies = <String>[].obs;
  RxList<String> projectImageLinks = <String>[].obs;
  RxList<XFile> projectImages = <XFile>[].obs;
  RxnString projectGithubLink = RxnString();
  RxnString projectGroupId = RxnString();
  Rx<ProjectStatus> projectStatus = ProjectStatus.proposed.obs;
  RxInt projectTechLen = 1.obs;
  RxInt projectFeatureLen = 1.obs;
  RxInt projectImageLen = 1.obs;
  final formKey = GlobalKey<FormState>();
  Rxn<File> projectReportingFile = Rxn<File>();
  Rxn<String> projectReportingFileLink = Rxn<String>();

  RxBool isUploading = false.obs;

  final supabase = Supabase.instance.client;

  void addFeature(String? feature) {
    projectFeatures.add(feature!);
  }

  void removeFeature(String? feature) {
    projectFeatures.remove(feature!);
  }

  void addTechnology(String? technology) {
    projectTechnologies.add(technology!);
  }

  void removeTechnology(String? technology) {
    projectTechnologies.remove(technology!);
  }

  String? validateName(String? value) {
    if ((GetUtils.isNullOrBlank(value) ?? false)) {
      return 'Name is required';
    }
    return null;
  }

  void saveName(String? value) {
    projectName.value = value!;
  }

  String? validateDescription(String? value) {
    if ((GetUtils.isNullOrBlank(value) ?? false)) {
      return 'Description is required';
    }
    return null;
  }

  void saveDescription(String? value) {
    projectDescription.value = value!;
  }

  String? validateFeature(String? value) {
    if ((GetUtils.isNullOrBlank(value) ?? false)) {
      return 'Feature is required';
    }
    return null;
  }

  String? validateTechnology(String? value) {
    if ((GetUtils.isNullOrBlank(value) ?? false)) {
      return 'Technology is required';
    }
    return null;
  }

  bool validateFeatures() {
    if (projectFeatures.isEmpty) {
      Get.snackbar(
        'Error',
        'At least one feature is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  bool validateTechnologies() {
    if (projectTechnologies.isEmpty) {
      Get.snackbar(
        'Error',
        'At least one technology is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  void saveGroupId(String? value) {
    projectGroupId.value = value;
  }

  bool validateGroupId() {
    if ((GetUtils.isNullOrBlank(projectGroupId) ?? false)) {
      Get.snackbar(
        'Error',
        'Group ID is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  void saveGithubLink(String? value) {
    projectGithubLink.value = value!;
  }

  addFeatureField() {
    projectTechLen.value++;
  }

  removeFeatureField() {
    if (projectTechLen.value > 1) {
      projectTechLen.value--;
    }
  }

  addTechnologyField() {
    projectFeatureLen.value++;
  }

  removeTechnologyField() {
    if (projectFeatureLen.value > 1) {
      projectFeatureLen.value--;
    }
  }

  removeImageField() {
    if (projectImageLen > 1) {
      projectImageLen.value--;
    }
  }

  void saveImages(List<XFile> images) {
    projectImages.addAll(images);
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (validateFeatures() && validateTechnologies() && validateGroupId()) {
        isUploading.value = true;
        Get.snackbar('Upload Started - images', 'Please wait...',
            snackPosition: SnackPosition.BOTTOM);
        for (var i = 0; i < projectImages.length; i++) {
          final fileName =
              '${projectName.value!.removeAllWhitespace}/${(i + 1).toString()}';
          final file = File(projectImages[i].path);
          await supabase.storage
              .from('projectImages')
              .upload('$fileName${p.extension(file.path)}', file);
          final url = supabase.storage
              .from('projectImages')
              .getPublicUrl('$fileName${p.extension(file.path)}');
          projectImageLinks.add(url);
        }

        Get.snackbar('Upload Started - report', 'Please wait...',
            snackPosition: SnackPosition.BOTTOM);

        if (projectReportingFile.value != null) {
          final fileName = '${projectName.value!.removeAllWhitespace}/report';
          await supabase.storage.from('projectReports').upload(
              '$fileName${p.extension(projectReportingFile.value!.path)}',
              projectReportingFile.value!);
          final url = supabase.storage.from('projectReports').getPublicUrl(
              '$fileName${p.extension(projectReportingFile.value!.path)}');
          projectReportingFileLink.value = url;
        }

        Get.snackbar('Upload Started - project', 'Please wait...',
            snackPosition: SnackPosition.BOTTOM);

        final response = await supabase.from('project').insert(
          {
            'name': projectName.value,
            'description': projectDescription.value,
            'features': projectFeatures.toList(),
            'technologies': projectTechnologies.toList(),
            'imageLinks': projectImageLinks.toList(),
            'githubLink': projectGithubLink.value,
            'status': projectStatus.value.name.toString(),
            'gid': projectGroupId.value,
            'reportLink': projectReportingFileLink.value,
          },
          defaultToNull: false,
        ).select();

        Get.snackbar('Project Created', 'Project has been created',
            snackPosition: SnackPosition.BOTTOM);
        print(response);
        isUploading.value = false;
        isUploaded.value = true;
      }
    }
  }
}
