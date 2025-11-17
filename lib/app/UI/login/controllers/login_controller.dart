import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final maroon = const Color(0xFF800000);

  // role: admin / user
  var userRole = "user".obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedRole();
  }

  /// ============================================
  /// LOAD ROLE dari SharedPreferences saat startup
  /// ============================================
  Future<void> _loadSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    userRole.value = prefs.getString("role") ?? "user";
  }

  /// ============================================
  /// LOGIN SYSTEM
  /// ============================================
  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password harus diisi");
      return;
    }

    // Username dari email
    final username = email.split("@").first;

    // ===============================
    // ROLE CHECKING
    // ===============================

    // ADMIN
    if (email == "admin@gmail.com" && password == "admin123") {
      userRole.value = "admin";
    }

    // USER
    else if (email == "user@gmail.com" && password == "user123") {
      userRole.value = "user";
    }

    // SALAH LOGIN
    else {
      Get.snackbar("Login Gagal", "Email atau password salah",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // ===============================
    // SIMPAN ROLE KE LOCAL STORAGE
    // ===============================
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", userRole.value);

    // Pesan sukses
    Get.snackbar("Login Berhasil", "Selamat datang, $username",
        backgroundColor: Colors.green, colorText: Colors.white);

    // Pindah halaman
    Get.offNamed(
      Routes.mainNavigation,
      arguments: {
        'username': username,
        'maroon': maroon,
      },
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
