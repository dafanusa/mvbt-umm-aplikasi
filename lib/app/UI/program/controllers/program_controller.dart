import 'package:get/get.dart';
import '../../../models/program_model.dart';
import '../../../../services/program_supabase_service.dart';
import '../../login/controllers/login_controller.dart';

class ProgramController extends GetxController {
  final ProgramSupabaseService supabaseService = ProgramSupabaseService();
  final LoginController loginC = Get.find<LoginController>();

  // DATA PROGRAM
  RxList<ProgramModel> programs = <ProgramModel>[].obs;

  // LOADING
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPrograms(); // langsung ambil dari SUPABASE
  }

  // =====================================================
  // AMBIL DATA DARI SUPABASE
  // =====================================================
  Future<void> getPrograms() async {
    try {
      isLoading.value = true;
      final result = await supabaseService.getPrograms();
      programs.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat program: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // TAMBAH PROGRAM → SUPABASE
  // =====================================================
  Future<void> addProgram(ProgramModel p) async {
    if (loginC.userRole.value != "admin") {
      Get.snackbar("Akses Ditolak", "Hanya admin yang boleh menambah program");
      return;
    }

    final ok = await supabaseService.addProgram(p);

    if (ok) {
      await getPrograms(); // WAJIB! Refresh data UI
      Get.back();
      Get.snackbar("Success", "Program berhasil ditambahkan");
    } else {
      Get.snackbar("Error", "Gagal menambah program");
    }
  }

  // =====================================================
  // UPDATE PROGRAM → SUPABASE
  // =====================================================
  Future<void> updateProgram(ProgramModel p) async {
    if (loginC.userRole.value != "admin") {
      Get.snackbar("Akses Ditolak", "Hanya admin yang boleh mengedit program");
      return;
    }

    final ok = await supabaseService.updateProgram(p);

    if (ok) {
      await getPrograms(); // refresh setelah update
      Get.back();
      Get.snackbar("Success", "Program diperbarui");
    } else {
      Get.snackbar("Error", "Gagal memperbarui program");
    }
  }

  // =====================================================
  // DELETE PROGRAM → SUPABASE
  // =====================================================
  Future<void> deleteProgram(int id) async {
    if (loginC.userRole.value != "admin") {
      Get.snackbar("Akses Ditolak", "Hanya admin yang boleh menghapus program");
      return;
    }

    final ok = await supabaseService.deleteProgram(id);

    if (ok) {
      await getPrograms(); // refresh setelah hapus
      Get.snackbar("Success", "Program dihapus");
    } else {
      Get.snackbar("Error", "Gagal menghapus program");
    }
  }
}
