import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;

  final supabase = Supabase.instance.client;

  Future<void> register(Color maroon) async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

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

      /// REGISTER ke SUPABASE AUTH (TANPA tabel users)
      await supabase.auth.signUp(
        email: email,
        password: pass,
      );

      Get.snackbar("Sukses", "Akun berhasil dibuat!");
      Get.back(); // Kembali ke login

    } on AuthException catch (e) {
      Get.snackbar("Auth Error", e.message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
