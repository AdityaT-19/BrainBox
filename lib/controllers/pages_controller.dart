import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenController extends GetxController {
  late PageController pageController;
  RxInt currentPage = 0.obs;
  void changePage(int index) {
    currentPage.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
