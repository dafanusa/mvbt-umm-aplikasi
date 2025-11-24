import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';
import 'package:mvbtummaplikasi/services/internet_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  final internet = InternetService();

  final maroon = const Color(0xFF800000);

  var isLoading = false.obs;
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();

    internet.connectionStream.listen((connected) {
      isOnline.value = connected;

      if (!connected) {
        Get.snackbar("Offline", "Tidak ada koneksi internet",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    });
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!await internet.checkConnection()) {
      Get.snackbar("Offline", "Internet diperlukan untuk login Supabase",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password harus diisi");
      return;
    }

    try {
      isLoading.value = true;

      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Simpan role default (user)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("role", "user");

      Get.offNamed(Routes.mainNavigation, arguments: {
        'username': email.split("@").first,
        'maroon': maroon,
      });
    } on AuthException catch (e) {
      Get.snackbar("Login Error", e.message,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
