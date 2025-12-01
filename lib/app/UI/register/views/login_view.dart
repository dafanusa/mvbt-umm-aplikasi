import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final emailC = TextEditingController();
  final passC = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailC,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        controller.emailController.text = emailC.text.trim();
                        controller.passwordController.text =
                            passC.text.trim();
                        controller.login(); // FIX: tanpa parameter
                      },
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text("Login"),
              );
            }),
            TextButton(
              onPressed: () => Get.toNamed("/register"),
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
