import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: controller.fadeAnimation,
            child: SlideTransition(
              position: controller.slideAnimation,
              child: ScaleTransition(
                scale: controller.scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ================= LOGO LEBIH BESAR =================
                    SizedBox(
                      width: 200, // ⬆️ dari 140
                      height: 200,
                      child: Image.asset(
                        'assets/mvbtnobg.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 36), // ⬆️ lebih lega
                    // ================= TITLE LEBIH BESAR =================
                    Text(
                      "MVBT Activity Manager",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28, // ⬆️ dari 22
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= SUBTITLE =================
                    Text(
                      "Kelola Kegiatan • Jadwal • Informasi",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, // ⬆️ dari 14
                        color: theme.colorScheme.onPrimary.withOpacity(0.9),
                      ),
                    ),

                    const SizedBox(height: 50), // ⬆️ lebih lapang
                    // ================= LOADING =================
                    SizedBox(
                      width: 42, // ⬆️ dari 36
                      height: 42,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
