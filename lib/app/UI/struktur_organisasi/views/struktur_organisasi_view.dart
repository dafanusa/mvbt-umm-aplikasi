import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/struktur_organisasi_controller.dart';
import '../../../models/struktur_organisasi_model.dart';
import 'package:flutter/foundation.dart'; // kIsWeb

class StrukturOrganisasiView extends GetView<StrukturOrganisasiController> {
  const StrukturOrganisasiView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginC = Get.find<LoginController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Struktur Organisasi"),
        backgroundColor: const Color.fromARGB(255, 122, 0, 0),
        foregroundColor: Colors.white,
      ),

      // ================= FAB ADMIN =================
      floatingActionButton: Obx(() {
        return loginC.userRole.value == "admin"
            ? FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 122, 0, 0),
                child: const Icon(Icons.add),
                onPressed: () => _showForm(context),
              )
            : const SizedBox.shrink();
      }),

      // ================= BODY =================
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ================= CARD INFO (TAMBAHAN SAJA) =================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 0, 0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Struktur Organisasi MVBT UMM",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Kepengurusan Periode 2025 – 2026",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= LIST STRUKTUR (TETAP) =================
            if (controller.list.isEmpty)
              const Center(child: Text("Data struktur belum ada"))
            else
              ...controller.list.map(
                (e) => _card(context, e, loginC.userRole.value == "admin"),
              ),
          ],
        );
      }),
    );
  }

  // ================= CARD ITEM =================
  Widget _card(
    BuildContext context,
    StrukturOrganisasiModel data,
    bool isAdmin,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          // ================= FOTO =================
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 72,
              height: 72,
              color: Colors.grey.shade200,
              child: data.fotoUrl != null && data.fotoUrl!.isNotEmpty
                  ? Image.network(
                      data.fotoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, size: 40),
                    )
                  : const Icon(Icons.person, size: 40),
            ),
          ),

          const SizedBox(width: 14),

          // ================= INFO =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.jabatan,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color.fromARGB(255, 122, 0, 0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.nama,
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ],
            ),
          ),

          // ================= MENU ADMIN =================
          if (isAdmin)
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'edit') _showForm(context, data: data);
                if (v == 'delete') controller.deleteData(data.id);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text("Edit")),
                PopupMenuItem(value: 'delete', child: Text("Hapus")),
              ],
            ),
        ],
      ),
    );
  }

  // ================= FORM ADD / EDIT =================
  void _showForm(BuildContext context, {StrukturOrganisasiModel? data}) {
    final namaC = TextEditingController(text: data?.nama ?? "");
    final jabatanC = TextEditingController(text: data?.jabatan ?? "");
    final urutanC = TextEditingController(text: data?.urutan.toString() ?? "0");

    final picker = ImagePicker();
    Rx<File?> pickedImage = Rx<File?>(null);
    Rx<Uint8List?> webImage = Rx<Uint8List?>(null);

    Get.defaultDialog(
      title: data == null ? "Tambah Struktur" : "Edit Struktur",
      content: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return GestureDetector(
                onTap: () async {
                  final img = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (img != null) pickedImage.value = File(img.path);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 110,
                    height: 110,
                    color: Colors.grey.shade300,
                    child: pickedImage.value != null
                        ? (kIsWeb
                              ? Image.memory(
                                  pickedImage.value!.readAsBytesSync(),
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  pickedImage.value!,
                                  fit: BoxFit.cover,
                                ))
                        : (data?.fotoUrl != null && data!.fotoUrl!.isNotEmpty
                              ? Image.network(data.fotoUrl!, fit: BoxFit.cover)
                              : const Icon(Icons.camera_alt, size: 36)),
                  ),
                ),
              );
            }),

            const SizedBox(height: 14),

            TextField(
              controller: namaC,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: jabatanC,
              decoration: const InputDecoration(labelText: "Jabatan"),
            ),
            TextField(
              controller: urutanC,
              decoration: const InputDecoration(labelText: "Urutan"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      onConfirm: () {
        if (data == null) {
          controller.addData(
            StrukturOrganisasiModel(
              id: 0,
              nama: namaC.text,
              jabatan: jabatanC.text,
              urutan: int.parse(urutanC.text),
            ),
            imageFile: pickedImage.value,
          );
        } else {
          controller.updateData(
            StrukturOrganisasiModel(
              id: data.id,
              nama: namaC.text,
              jabatan: jabatanC.text,
              fotoUrl: data.fotoUrl,
              urutan: int.parse(urutanC.text),
            ),
            imageFile: pickedImage.value,
          );
        }
        Get.back();
      },
    );
  }
}
