import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final nameC = TextEditingController();

  final role = "user".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameC, decoration: InputDecoration(labelText: "Nama")),
            TextField(controller: emailC, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passC, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            
            Obx(() {
              return DropdownButton(
                value: role.value,
                items: [
                  DropdownMenuItem(value: "user", child: Text("User")),
                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                ],
                onChanged: (v) => role.value = v!,
              );
            }),
            
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => controller.register(
                emailC.text,
                passC.text,
                nameC.text,
                role.value,
              ),
              child: Text("Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}
