import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart'; // Sesuaikan dengan path routes Abang

class ProfileController extends GetxController {
  final isEditing = false.obs;
  final email = "".obs;
  final namaLengkap = "".obs;
  final nim = "".obs;
  final jabatan = "".obs;
  final status = "Aktif".obs;

  late TextEditingController namaC;
  late TextEditingController nimC;
  late TextEditingController jabatanC;
  late TextEditingController statusC;

  final supabase = Supabase.instance.client;
  final String adminEmail = "admin@gmail.com";

  @override
  void onInit() {
    super.onInit();
    final user = supabase.auth.currentUser;
    final authEmail = user?.email ?? "-";

    if (authEmail == adminEmail) {
      email.value = adminEmail;
      namaLengkap.value = adminEmail;
      jabatan.value = "Admin";
    } else {
      email.value = authEmail;
      namaLengkap.value = "";
      jabatan.value = "Anggota";
    }

    namaC = TextEditingController(text: namaLengkap.value);
    nimC = TextEditingController(text: nim.value);
    jabatanC = TextEditingController(text: jabatan.value);
    statusC = TextEditingController(text: status.value);
  }

  void toggleEdit() {
    if (isEditing.value) {
      namaLengkap.value = namaC.text;
      nim.value = nimC.text;
      jabatan.value = jabatanC.text;
      status.value = statusC.text;
    }
    isEditing.toggle();
  }

  // 🔥 TARUH DI SINI BANG
  Future<void> logout() async {
    try {
      // 1. Proses Logout dari Supabase (Hapus Session di Server)
      await supabase.auth.signOut();

      // 2. Bersihkan SharedPreferences (Hapus Role dll)
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 3. Tendang ke halaman Login dan hapus semua history page sebelumnya
      Get.offAllNamed(Routes.login);

      debugPrint("DEBUG: Logout berhasil, session dibersihkan.");
    } catch (e) {
      Get.snackbar("Error Logout", e.toString());
    }
  }

  @override
  void onClose() {
    namaC.dispose();
    nimC.dispose();
    jabatanC.dispose();
    statusC.dispose();
    super.onClose();
  }
}
