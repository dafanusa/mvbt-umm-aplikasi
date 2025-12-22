import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../login/controllers/login_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final isEditing = false.obs;

  final email = "".obs;

  final namaLengkap = "".obs; // default kosong
  final nim = "".obs;
  final jabatan = "".obs;
  final status = "Aktif".obs;

  late TextEditingController namaC;
  late TextEditingController nimC;
  late TextEditingController jabatanC;
  late TextEditingController statusC;

  final supabase = Supabase.instance.client;

  // 🔐 EMAIL ADMIN
  final String adminEmail = "admin@gmail.com";

  @override
  void onInit() {
    super.onInit();

    final user = supabase.auth.currentUser;
    final authEmail = user?.email ?? "-";

    // 🧠 LOGIC ADMIN / USER
    if (authEmail == adminEmail) {
      // admin login pakai email admin
      email.value = adminEmail;
      namaLengkap.value = adminEmail;
      jabatan.value = "Admin";
    } else {
      // user biasa
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

  @override
  void onClose() {
    namaC.dispose();
    nimC.dispose();
    jabatanC.dispose();
    statusC.dispose();
    super.onClose();
  }
}
