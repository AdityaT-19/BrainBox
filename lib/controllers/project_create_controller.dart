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
  RxList<String> projectFeatures = <String>[
    '',
  ].obs;
  RxList<String> projectTechnologies = <String>[
    '',
  ].obs;
  RxList<String> projectImageLinks = <String>[].obs;
  RxList<XFile> projectImages = <XFile>[].obs;
  RxnString projectGithubLink = RxnString();
  RxnString projectGroupId = RxnString();
  Rx<ProjectStatus> projectStatus = ProjectStatus.proposed.obs;
  // RxInt projectTechLen = 1.obs;
  // RxInt projectFeatureLen = 1.obs;
  // RxInt projectImageLen = 1.obs;
  final formKey = GlobalKey<FormState>();
  Rxn<File> projectReportingFile = Rxn<File>();
  Rxn<String> projectReportingFileLink = Rxn<String>();

  RxBool isUploading = false.obs;

  final supabase = Supabase.instance.client;

  void addFeature(String? feature, int index) {
    projectFeatures[index] = feature!;
  }

  // void removeFeature(String? feature,int index) {
  //   projectFeatures.remove(feature!);
  // }

  void addTechnology(String? technology, int index) {
    projectTechnologies[index] = technology!;
  }

  // void removeTechnology(String? technology,int index) {
  //   projectTechnologies.remove(technology!);
  // }

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

  // addFeatureField() {
  //   projectTechLen.value++;
  // }

  // removeFeatureField() {
  //   if (projectTechLen.value > 1) {
  //     projectTechLen.value--;
  //   }
  // }

  // addTechnologyField() {
  //   projectFeatureLen.value++;
  // }

  // removeTechnologyField() {
  //   if (projectFeatureLen.value > 1) {
  //     projectFeatureLen.value--;
  //   }
  // }

  // removeImageField() {
  //   if (projectImageLen > 1) {
  //     projectImageLen.value--;
  //   }
  // }

  void saveImages(List<XFile> images) {
    projectImages.addAll(images);
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (validateFeatures() && validateTechnologies() && validateGroupId()) {
        isUploading.value = true;

        Get.snackbar('Upload Started - project', 'Please wait...',
            snackPosition: SnackPosition.BOTTOM);

        final response = await supabase
            .from('project')
            .insert(
              {
                'name': projectName.value,
                'description': projectDescription.value,
                'features': projectFeatures.toList(),
                'technologies': projectTechnologies.toList(),
                'githubLink': projectGithubLink.value,
                'status': projectStatus.value.name.toString(),
                'imageLinks': <String>[].toList(),
                'gid': projectGroupId.value,
              },
            )
            .select()
            .single();

        final pid = response['pid'] as String;

        Get.snackbar('Upload Started - images', 'Please wait...',
            snackPosition: SnackPosition.BOTTOM);

        await Future.forEach(
          projectImages,
          (element) async {
            final file = File(element.path);
            final extension = p.extension(file.path);
            final fileName =
                '$pid/${(projectImages.indexOf(element) + 1)}$extension';
            await supabase.storage.from('projectImages').upload(
                  fileName,
                  file,
                );
            final url = supabase.storage.from('projectImages').getPublicUrl(
                  fileName,
                );
            projectImageLinks.add(url);
          },
        );

        Get.snackbar('Upload Started - report', 'Please wait...',
            snackPosition: SnackPosition.BOTTOM);

        if (projectReportingFile.value != null) {
          final fileName = '$pid/report.pdf';
          await supabase.storage.from('projectReports').upload(
                fileName,
                projectReportingFile.value!,
              );
          final url = supabase.storage.from('projectReports').getPublicUrl(
                fileName,
              );
          projectReportingFileLink.value = url;
        }

        final project = await supabase
            .from('project')
            .update(
              {
                'imageLinks': projectImageLinks.toList(),
                'reportLink': projectReportingFileLink.value
              },
            )
            .eq('pid', pid)
            .select()
            .select();

        Get.snackbar('Project Created', 'Project has been created',
            snackPosition: SnackPosition.BOTTOM);

        print(project);
        isUploading.value = false;
        isUploaded.value = true;
      }
    }
  }
}
