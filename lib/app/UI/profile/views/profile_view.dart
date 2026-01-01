import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:mvbtummaplikasi/app/routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key, required String username});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maroon = const Color.fromARGB(255, 122, 0, 0);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 24),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 122, 0, 0),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 48, color: maroon),
                  ),
                  const SizedBox(height: 10),

                  Obx(
                    () => Text(
                      controller.namaLengkap.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Obx(
                    () => Text(
                      controller.nim.value,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= INFORMASI PRIBADI =================
            _infoSection(
              context,
              title: "Informasi Pribadi",
              icon: Icons.person_outline,
              children: [
                _editableItem(
                  icon: Icons.badge,
                  label: "Nama Lengkap",
                  controller: controller.namaC,
                ),
                _editableItem(
                  icon: Icons.credit_card,
                  label: "NIM",
                  controller: controller.nimC,
                ),
                _readonlyItem(Icons.email, "Email", controller.email.value),
              ],
            ),

            const SizedBox(height: 16),

            // ================= DETAIL ORGANISASI =================
            _infoSection(
              context,
              title: "Detail Organisasi",
              icon: Icons.apartment,
              children: [
                _editableItem(
                  icon: Icons.work,
                  label: "Jabatan",
                  controller: controller.jabatanC,
                ),
                _editableItem(
                  icon: Icons.verified_user,
                  label: "Status",
                  controller: controller.statusC,
                ),
                const SizedBox(height: 12),

                // ===== STRUKTUR ORGANISASI (TETAP ADA) =====
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.strukturorganisasi);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: maroon.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.account_tree, color: maroon),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Lihat Struktur Organisasi",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: maroon,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 14, color: maroon),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ================= EDIT BUTTON =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.toggleEdit,
                  icon: Icon(
                    controller.isEditing.value ? Icons.save : Icons.edit,
                  ),
                  label: Text(
                    controller.isEditing.value
                        ? "Simpan Perubahan"
                        : "Edit Profil",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================= LOGOUT =================

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton.icon(
                onPressed: () {
                  // Memanggil fungsi logout yang sudah kita buat di ProfileController
                  controller.logout();
                },
                icon: const Icon(Icons.logout),
                label: const Text("Keluar"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: maroon,
                  side: BorderSide(color: maroon),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= INFO SECTION =================
  Widget _infoSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    const maroon = Color.fromARGB(255, 122, 0, 0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: maroon),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: maroon,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // ================= EDITABLE ITEM =================
  Widget _editableItem({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    final profileC = Get.find<ProfileController>();

    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: profileC.isEditing.value
            ? TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  prefixIcon: Icon(icon),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            : _readonlyItem(icon, label, controller.text),
      );
    });
  }

  // ================= READONLY ITEM =================
  Widget _readonlyItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
