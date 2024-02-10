import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormUtils {
  Widget customHeader(String title) {
    return Padding(
      padding: EdgeInsets.all(Get.height * 0.01),
      child: Text(
        title,
        style: Get.textTheme.titleLarge!.copyWith(
          color: Get.theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget customTextFormField(
      {String? labelText,
      String? Function(String?)? validator,
      void Function(String?)? onSaved,
      String? helperText,
      String? initialValue}) {
    return Padding(
      padding: EdgeInsets.all(Get.height * 0.01),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Get.theme.colorScheme.secondaryContainer,
            ),
          ),
          fillColor: Get.theme.colorScheme.secondaryContainer,
          helperText: helperText,
        ),
        validator: validator,
        onSaved: onSaved,
        initialValue: initialValue,
        style: Get.textTheme.bodyLarge!.copyWith(
          color: Get.theme.colorScheme.onBackground,
        ),
      ),
    );
  }
}
