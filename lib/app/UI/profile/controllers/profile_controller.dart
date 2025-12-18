import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../login/controllers/login_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final isEditing = false.obs;

  // DATA DARI LOGIN
  final email = "".obs; // diisi dari login

  // DATA PROFILE
  final namaLengkap = "Soekarno Hatta".obs;
  final nim = "202310370311200".obs;
  final jabatan = "Ketua Umum".obs;
  final status = "Aktif".obs;

  late TextEditingController namaC;
  late TextEditingController nimC;
  late TextEditingController jabatanC;
  late TextEditingController statusC;

  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();

    // CONTOH: email dari login
    email.value = Get.arguments?['email'] ?? "user@gmail.com";

    namaC = TextEditingController(text: namaLengkap.value);
    nimC = TextEditingController(text: nim.value);
    jabatanC = TextEditingController(text: jabatan.value);
    statusC = TextEditingController(text: status.value);
  }

  void toggleEdit() {
    if (isEditing.value) {
      // SIMPAN
      namaLengkap.value = namaC.text;
      nim.value = nimC.text;
      jabatan.value = jabatanC.text;
      status.value = statusC.text;

      // TODO: simpan ke Supabase / Firebase
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
