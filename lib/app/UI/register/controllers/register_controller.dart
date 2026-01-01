import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mvbtummaplikasi/services/internet_service.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final supabase = Supabase.instance.client;
  final internet = InternetService();

  var isLoading = false.obs;

  Future<void> register(Color maroon) async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (!await internet.checkConnection()) {
      Get.snackbar("Offline", "Nyalakan internet");
      return;
    }

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      Get.snackbar("Error", "Semua field wajib diisi");
      return;
    }

    if (pass != confirm) {
      Get.snackbar("Error", "Password tidak cocok");
      return;
    }

    try {
      isLoading.value = true;

      final res = await supabase.auth.signUp(email: email, password: pass);

      if (res.user == null) {
        Get.snackbar("Gagal", "Registrasi gagal");
        return;
      }

      // ✅ SNACKBAR SUKSES
      Get.snackbar(
        "Berhasil 🎉",
        "Akun berhasil dibuat",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 800));

      // ✅ PINDAH KE LOGIN + ISI OTOMATIS
      Get.offNamed(Routes.login, arguments: {"email": email, "password": pass});
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
