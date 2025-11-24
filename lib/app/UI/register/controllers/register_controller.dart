import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/views/login_view.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isLoading = false.obs;

  bool validateForm() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Semua field wajib diisi!',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Peringatan',
        'Password dan konfirmasi password tidak cocok!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  void register(Color maroon) async {
    if (!validateForm()) return;
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1)); // simulasi
    isLoading.value = false;

    Get.snackbar(
      'Berhasil',
      'Akun berhasil dibuat! Silakan login.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.offAll(() => LoginView(maroon: maroon));
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
