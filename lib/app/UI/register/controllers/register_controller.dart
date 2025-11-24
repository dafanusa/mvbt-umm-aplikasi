import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mvbtummaplikasi/services/internet_service.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final supabase = Supabase.instance.client;
  final internet = InternetService();

  var isLoading = false.obs;
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();

    // Update status online
    internet.connectionStream.listen((connected) {
      isOnline.value = connected;

      if (!connected) {
        Get.snackbar(
          "Offline",
          "No internet connection",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }

  Future<void> register(Color maroon) async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (!await internet.checkConnection()) {
      Get.snackbar("Tidak ada internet", "Nyalakan internet untuk register",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      Get.snackbar("Error", "Semua field wajib diisi!");
      return;
    }

    if (pass != confirm) {
      Get.snackbar("Error", "Password dan konfirmasi tidak cocok!");
      return;
    }

    try {
      isLoading.value = true;

      final response = await supabase.auth.signUp(
        email: email,
        password: pass,
      );

      if (response.user == null) {
        Get.snackbar("Error", "Registrasi gagal");
        return;
      }

      Get.snackbar("Sukses", "Akun berhasil dibuat! Silakan login.",
          backgroundColor: Colors.green, colorText: Colors.white);

      Get.back();
    } on AuthException catch (e) {
      Get.snackbar("Auth Error", e.message,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
