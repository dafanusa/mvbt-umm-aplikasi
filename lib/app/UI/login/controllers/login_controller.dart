import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';
import '../../notification/controllers/notification_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  final maroon = const Color(0xFF800000);
  var userRole = "user".obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedRole();
  }

  Future<void> _loadSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    userRole.value = prefs.getString("role") ?? "user";
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password harus diisi");
      return;
    }

    final username = email.split("@").first;
    final notificationController = Get.find<NotificationController>();

    // ===============================
    // 1. LOGIN ADMIN (MANUAL)
    // ===============================
    if (email == "admin@gmail.com" && password == "admin123") {
      userRole.value = "admin";

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("role", "admin");

      Get.snackbar(
        "Admin Login",
        "Selamat datang Admin $username",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offNamed(
        Routes.mainNavigation,
        arguments: {'username': username, 'maroon': maroon},
      );
      return;
    }

    // ===============================
    // 2. LOGIN USER SUPABASE
    // ===============================
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        Get.snackbar(
          "Login Gagal",
          "User tidak ditemukan",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      userRole.value = "user";

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("role", "user");

      Get.snackbar(
        "Login Berhasil",
        "Selamat datang, $username",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offNamed(
        Routes.mainNavigation,
        arguments: {'username': username, 'maroon': maroon},
      );
    }
    // ===============================
    // ERROR dari Supabase
    // ===============================
    catch (e) {
      Get.snackbar(
        "Login Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
