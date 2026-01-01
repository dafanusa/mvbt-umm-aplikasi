import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

    // Minta izin notif (WAJIB ANDROID 13+)
    FirebaseMessaging.instance.requestPermission();

    // Auto refresh token - Hanya update jika user benar-benar login
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final user = supabase.auth.currentUser;
      if (user != null) {
        debugPrint("DEBUG: Auto-refresh token untuk email: ${user.email}");
        await supabase.from('users').upsert({
          'id': user.id,
          'fcm_token': newToken,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
    });

    internet.connectionStream.listen((connected) {
      isOnline.value = connected;
      if (!connected) {
        Get.snackbar(
          "Offline",
          "Tidak ada koneksi internet",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 1. Validasi Awal
    if (!await internet.checkConnection()) {
      Get.snackbar("Offline", "Internet diperlukan untuk login");
      return;
    }

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password harus diisi");
      return;
    }

    try {
      isLoading.value = true;

      // 2. Ambil Token FCM lebih dulu agar siap dikirim
// --- Bagian Ambil Token di Fungsi login() ---
      String? fcmToken;
      int retryCount = 0;

      // Coba ambil token sampai 3 kali jika gagal/null
      while (fcmToken == null && retryCount < 3) {
        try {
          fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken == null) {
            await Future.delayed(
              const Duration(seconds: 2),
            ); // Tunggu 2 detik sebelum coba lagi
            retryCount++;
            debugPrint("DEBUG: Token null, mencoba lagi ke-$retryCount...");
          }
        } catch (e) {
          debugPrint("DEBUG: Error ambil token: $e");
          break;
        }
      }
      // 3. Login ke Supabase
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user == null) throw "User tidak ditemukan";

      // 4. Sinkronisasi Data ke Tabel Users
      // Menggunakan UPSERT dengan ID hasil login agar token TIDAK NYASAR
      await supabase.from('users').upsert({
        'id': user.id, // Primary Key untuk identifikasi row
        'email': user.email,
        'fcm_token': fcmToken,
        'last_login': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      debugPrint("DEBUG: Token berhasil disinkronkan untuk: ${user.email}");

      // 5. Simpan Session & Navigasi
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("role", "user");

      Get.offNamed(
        Routes.mainNavigation,
        arguments: {'username': email.split("@").first, 'maroon': maroon},
      );
    } catch (e) {
      Get.snackbar(
        "Login Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
