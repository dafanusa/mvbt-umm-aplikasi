import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.find<LoginController>();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  bool _filled = false; // 🔑 supaya cuma diisi sekali

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_filled) {
      final args = Get.arguments;

      if (args != null && args is Map) {
        emailC.text = args["email"] ?? "";
        passC.text = args["password"] ?? "";
      }

      _filled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),

            Obx(() {
              return ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        controller.emailController.text = emailC.text.trim();
                        controller.passwordController.text = passC.text.trim();
                        controller.login();
                      },
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              );
            }),

            TextButton(
              onPressed: () => Get.toNamed("/register"),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
