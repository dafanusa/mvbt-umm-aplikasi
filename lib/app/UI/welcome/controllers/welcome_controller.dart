import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void goToLogin() {
    Get.toNamed('/login');
  }

  void goToRegister() {
    Get.toNamed('/register');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
