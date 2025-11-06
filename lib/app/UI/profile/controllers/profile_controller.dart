import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mvbtummaplikasi/app/routes/app_pages.dart';
import '../../login/views/login_view.dart';

class ProfileController extends GetxController {
  void logout() {
    Get.offAllNamed(Routes.login);
  }
}
