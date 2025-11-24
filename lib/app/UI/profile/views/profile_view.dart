import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mvbtummaplikasi/app/routes/app_pages.dart';
import '../../login/views/login_view.dart';

class ProfileView extends StatelessWidget {
  final String username;
  final Color maroon;
  const ProfileView({super.key, required this.username, required this.maroon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 24),
              decoration: BoxDecoration(
                color: maroon,
                borderRadius: const BorderRadius.vertical(
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
                  const Text(
                    'Soekarno Hatta',
                    style: TextStyle(
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
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Ketua Umum',
                      style: TextStyle(
                        color: maroon,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _statCard(Icons.event, '24', 'Kegiatan', maroon),
                        const SizedBox(width: 20),
                        _statCard(Icons.emoji_events, '4', 'Prestasi', maroon),
                        const SizedBox(width: 20),
                        _statCard(
                          Icons.calendar_today,
                          '30 Sept 1965',
                          'Bergabung',
                          maroon,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _infoSection(
              context,
              title: 'Informasi Pribadi',
              icon: Icons.person_outline,
              maroon: maroon,
              children: const [
                _infoItem(Icons.badge, 'Nama Lengkap', 'Soekarno Hatta'),
                _infoItem(Icons.credit_card, 'NIM', '202310370311200'),
                _infoItem(Icons.email, 'Email', 'soekarno.hatta@gmail.com'),
              ],
            ),

            const SizedBox(height: 16),
            _infoSection(
              context,
              title: 'Detail Organisasi',
              icon: Icons.apartment,
              maroon: maroon,
              children: const [
                _infoItem(Icons.work, 'Jabatan', 'Ketua Umum'),
                _infoItem(Icons.verified_user, 'Status Keanggotaan', 'Aktif'),
              ],
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.offAllNamed(Routes.login);
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Keluar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: maroon,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color maroon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _infoSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
    required Color maroon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: maroon,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Icon(Icons.edit, size: 18, color: maroon),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
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
