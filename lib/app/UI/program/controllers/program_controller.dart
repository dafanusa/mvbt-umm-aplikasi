import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/program_model.dart';

class ProgramController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final programs = <ProgramModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    getPrograms();
    super.onInit();
  }

  /// ==========================
  ///        GET PROGRAMS
  /// ==========================
  Future<void> getPrograms() async {
    isLoading.value = true;
    try {
      final data = await _supabase
          .from('programs')
          .select('*')
          .order('date', ascending: true);

      programs.value = data
          .map<ProgramModel>((json) => ProgramModel.fromJson(json))
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ==========================
  ///         ADD PROGRAM
  /// ==========================
  Future<void> addProgram(ProgramModel program) async {
    try {
      // Gunakan toJson() — TANPA id
      await _supabase.from('programs').insert(program.toJson());

      Get.snackbar("Berhasil", "Program berhasil ditambahkan.");
      await getPrograms();
    } catch (e) {
      Get.snackbar("Error", "Gagal menambah program: $e");
    }
  }

  /// ==========================
  ///       UPDATE PROGRAM
  /// ==========================
  Future<void> updateProgram(ProgramModel program) async {
    try {
      final updateData = {
        'title': program.title,
        'description': program.description,
        'date': program.date,
        'status': program.status,
      };

      await _supabase.from('programs').update(updateData).eq('id', program.id);

      Get.snackbar("Berhasil", "Program berhasil diperbarui.");
      await getPrograms();
    } catch (e) {
      Get.snackbar("Error", "Gagal update program: $e");
    }
  }

  /// ==========================
  ///       DELETE PROGRAM
  /// ==========================
  Future<void> deleteProgram(int id) async {
    try {
      await _supabase.from('programs').delete().eq('id', id);

      programs.removeWhere((p) => p.id == id);

      Get.snackbar("Berhasil", "Program berhasil dihapus.");
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus program: $e");
    }
  }
}
