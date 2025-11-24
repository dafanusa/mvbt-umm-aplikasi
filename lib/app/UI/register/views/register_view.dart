import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends StatefulWidget {
  final Color maroon;
  const RegisterView({super.key, required this.maroon});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.30,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: widget.maroon,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logomvbt.jpg', height: 90),
                      const SizedBox(height: 12),
                      const Text(
                        'MVBT ACTIVITY MANAGER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Muhammadiyah Volleyball Team\nUniversitas Muhammadiyah Malang',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silahkan buat akun Anda untuk mengakses\nAplikasi Manajemen Kegiatan MVBT UMM',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildField('Email', controller.emailController),
                      const SizedBox(height: 16),
                      _buildField('Password', controller.passwordController,
                          isPassword: true),
                      const SizedBox(height: 16),
                      _buildField('Konfirmasi Password',
                          controller.confirmPasswordController,
                          isPassword: true),
                      const SizedBox(height: 24),
                      Obx(() {
                        return ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.register(widget.maroon),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.maroon,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(color: Colors.white),
                                ),
                        );
                      }),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Text(
                          'Sudah punya akun?',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text('Or continue with'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(Icons.g_mobiledata),
                          _socialButton(Icons.facebook),
                          _socialButton(Icons.apple),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.maroon),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: IconButton(icon: Icon(icon, size: 28), onPressed: () {}),
    );
  }
}
