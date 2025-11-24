import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/program_controller.dart';
import '../../../models/program_model.dart';

class ProgramView extends GetView<ProgramController> {
  final Color maroon;
  ProgramView({super.key, required this.maroon});

  final LoginController loginC = Get.find<LoginController>();
  final RxString _selectedFilter = "Semua".obs;

  // ============================
  // ADD PROGRAM
  // ============================
  void _showAddProgramDialog() {
    final titleC = TextEditingController();
    final descC = TextEditingController();
    final dateC = TextEditingController();

    Get.defaultDialog(
      title: "Tambah Program",
      content: Column(
        children: [
          TextField(controller: titleC, decoration: const InputDecoration(labelText: "Judul")),
          TextField(controller: descC, decoration: const InputDecoration(labelText: "Deskripsi")),
          TextField(controller: dateC, decoration: const InputDecoration(labelText: "Tanggal (YYYY-MM-DD)")),
        ],
      ),
      textConfirm: "Tambah",
      textCancel: "Batal",
      onConfirm: () {
        final p = ProgramModel(
          id: 0,
          title: titleC.text,
          description: descC.text,
          date: dateC.text,
          status: "", // akan dihitung otomatis
        );

        controller.addProgram(p);
        Get.back();
      },
    );
  }

  // ============================
  // EDIT PROGRAM
  // ============================
  void _showEditProgramDialog(ProgramModel p) {
    final titleC = TextEditingController(text: p.title);
    final descC = TextEditingController(text: p.description);
    final dateC = TextEditingController(text: p.date);

    Get.defaultDialog(
      title: "Edit Program",
      content: Column(
        children: [
          TextField(controller: titleC, decoration: const InputDecoration(labelText: "Judul")),
          TextField(controller: descC, decoration: const InputDecoration(labelText: "Deskripsi")),
          TextField(controller: dateC, decoration: const InputDecoration(labelText: "Tanggal")),
        ],
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      onConfirm: () {
        final updated = ProgramModel(
          id: p.id,
          title: titleC.text,
          description: descC.text,
          date: dateC.text,
          status: "",
        );

        controller.updateProgram(updated);
        Get.back();
      },
    );
  }

  // ============================
  // CARD
  // ============================
  Widget _buildProgramCard(ProgramModel p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.title,
              style: TextStyle(
                  color: maroon, fontSize: 16, fontWeight: FontWeight.bold)),

          const SizedBox(height: 6),

          Text(p.description, style: const TextStyle(fontSize: 13)),

          const SizedBox(height: 8),

          Text("📅 ${p.date}", style: const TextStyle(fontSize: 12, color: Colors.black54)),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: p.status == "Sedang Berlangsung"
                    ? Colors.green
                    : p.status == "Selesai"
                        ? Colors.grey
                        : Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(p.status,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),

          if (loginC.userRole.value == "admin")
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showEditProgramDialog(p),
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () => controller.deleteProgram(p.id),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            )
        ],
      ),
    );
  }

  // ============================
  // MAIN UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maroon,
        title: const Text("Program Kerja", style: TextStyle(color: Colors.white)),
        actions: [
          if (loginC.userRole.value == "admin")
            IconButton(
                onPressed: _showAddProgramDialog,
                icon: const Icon(Icons.add, color: Colors.white)),
          IconButton(
            onPressed: () => controller.getPrograms(),   // <-- FIXED
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<ProgramModel> list = controller.programs;

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: list.length,
          itemBuilder: (_, i) => _buildProgramCard(list[i]),
        );
      }),
    );
  }
}
