import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../main_navigation/views/main_navigation_view.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final maroon = const Color(0xFF800000);

  void login() {
    final username = emailController.text.isEmpty
        ? 'Player'
        : emailController.text.split('@').first;
    Get.toNamed(
      Routes.mainNavigation,
      arguments: {'username': username, 'maroon': maroon},
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
