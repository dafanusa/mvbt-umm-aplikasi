import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mvbtummaplikasi/app/core/values/app_colors.dart';
import 'package:mvbtummaplikasi/app/routes/app_pages.dart';

class ProfileView extends StatelessWidget {
  final String username;

  const ProfileView({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 24),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 0, 0), 
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 48, color: const Color.fromARGB(255, 122, 0, 0)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username.isEmpty ? "Nama Pengguna" : username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '202310370311200',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
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
              children: const [
                _infoItem(Icons.badge, "Nama Lengkap", "Soekarno Hatta"),
                _infoItem(Icons.credit_card, "NIM", "202310370311200"),
                _infoItem(Icons.email, "Email", "soekarno.hatta@gmail.com"),
              ],
            ),

            const SizedBox(height: 16),

            // ================= ORGANISASI =================
            _infoSection(
              context,
              title: "Detail Organisasi",
              icon: Icons.apartment,
              children: const [
                _infoItem(Icons.work, "Jabatan", "Ketua Umum"),
                _infoItem(Icons.verified_user, "Status", "Aktif"),
              ],
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.offAllNamed(Routes.login);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Keluar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 122, 0, 0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  // SECTION BOX
  Widget _infoSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color.fromARGB(255, 122, 0, 0)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 122, 0, 0),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Icon(Icons.edit, size: 18, color: const Color.fromARGB(255, 122, 0, 0)),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _infoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _infoItem(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
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
