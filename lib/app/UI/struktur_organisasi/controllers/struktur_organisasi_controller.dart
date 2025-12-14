import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import '../../../models/struktur_organisasi_model.dart';

class StrukturOrganisasiController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final isLoading = false.obs;
  final list = <StrukturOrganisasiModel>[].obs;

  // ganti sesuai bucket kamu
  final String bucketName = 'struktur-organisasi';

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // ================= FETCH =================
  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final res = await supabase
          .from('struktur_organisasi')
          .select()
          .order('urutan', ascending: true);

      list.assignAll(
        (res as List).map((e) => StrukturOrganisasiModel.fromJson(e)).toList(),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= UPLOAD FOTO =================
  Future<String?> _uploadFoto(File file) async {
    try {
      final ext = p.extension(file.path);
      final fileName = 'struktur_${DateTime.now().millisecondsSinceEpoch}$ext';

      await supabase.storage.from(bucketName).upload(fileName, file);

      return supabase.storage.from(bucketName).getPublicUrl(fileName);
    } catch (e) {
      Get.snackbar("Upload gagal", e.toString());
      return null;
    }
  }

  // ================= ADD =================
  Future<void> addData(StrukturOrganisasiModel data, {File? imageFile}) async {
    try {
      isLoading.value = true;

      String? fotoUrl = data.fotoUrl;

      if (imageFile != null) {
        fotoUrl = await _uploadFoto(imageFile);
      }

      await supabase.from('struktur_organisasi').insert({
        'nama': data.nama,
        'jabatan': data.jabatan,
        'foto_url': fotoUrl,
        'urutan': data.urutan,
      });

      await fetchData();
    } catch (e) {
      Get.snackbar("Gagal tambah", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= UPDATE =================
  Future<void> updateData(
    StrukturOrganisasiModel data, {
    File? imageFile,
  }) async {
    try {
      isLoading.value = true;

      String? fotoUrl = data.fotoUrl;

      if (imageFile != null) {
        fotoUrl = await _uploadFoto(imageFile);
      }

      await supabase
          .from('struktur_organisasi')
          .update({
            'nama': data.nama,
            'jabatan': data.jabatan,
            'foto_url': fotoUrl,
            'urutan': data.urutan,
          })
          .eq('id', data.id);

      await fetchData();
    } catch (e) {
      Get.snackbar("Gagal update", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= DELETE =================
  Future<void> deleteData(int id) async {
    try {
      isLoading.value = true;

      await supabase.from('struktur_organisasi').delete().eq('id', id);

      await fetchData();
    } catch (e) {
      Get.snackbar("Gagal hapus", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
