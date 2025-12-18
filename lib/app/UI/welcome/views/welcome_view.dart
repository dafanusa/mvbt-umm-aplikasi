import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maroon = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ================= PAGE VIEW =================
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: const [
                  _AnimatedWelcomePage(
                    image: 'assets/welcome1.png',
                    title: 'MVBT ACTIVITY MANAGER APPLICATION',
                    subtitle:
                        'Manajemen Kegiatan\nMuhammadiyah Volleyball Team\nUniversitas Muhammadiyah Malang',
                  ),
                  _AnimatedWelcomePage(
                    image: 'assets/welcome2.jpg',
                    title: 'KELOLA JADWAL LATIHAN MVBT UMM',
                    subtitle:
                        'Latihan, pertandingan, dan agenda organisasi\ntersusun rapi dan terpantau dalam satu aplikasi',
                  ),
                  _AnimatedWelcomePage(
                    image: 'assets/welcome3.jpg',
                    title: 'INFORMASI TERPUSAT DAN TERUPDATE',
                    subtitle:
                        'Pengumuman penting dan kegiatan terbaru\nlangsung dari pengurus MVBT UMM',
                  ),
                ],
              ),
            ),

            // ================= INDICATOR =================
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final active = controller.currentPage.value == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: active ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? maroon : maroon.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 28),

            // ================= BUTTON =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.goToLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: maroon,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.goToRegister,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: maroon,
                        side: BorderSide(color: maroon, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// PAGE DENGAN ANIMASI (PUTIH CLEAN)
// =============================================================
class _AnimatedWelcomePage extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;

  const _AnimatedWelcomePage({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_AnimatedWelcomePage> createState() => _AnimatedWelcomePageState();
}

class _AnimatedWelcomePageState extends State<_AnimatedWelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maroon = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            children: [
              // ================= IMAGE (FULL FEEL) =================
              Expanded(
                flex: 6,
                child: Center(
                  child: Image.asset(
                    widget.image,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ================= TITLE (BESAR) =================
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30, // ⬅ LEBIH BESAR
                  fontWeight: FontWeight.w800,
                  color: maroon,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 18),

              // ================= SUBTITLE =================
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, // ⬅ LEBIH BESAR
                  color: Colors.black.withOpacity(0.75),
                  height: 1.6,
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
