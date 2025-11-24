import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/providers/theme_provider.dart';

class ThemeController extends GetxController {
  final ThemeProvider prefs = ThemeProvider();

  RxBool isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    isDark.value = await prefs.loadTheme();
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    prefs.saveTheme(isDark.value);

    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}