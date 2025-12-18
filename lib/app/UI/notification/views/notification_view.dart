import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Notifikasi")),
      body: Center(
        child: Obx(() {
          return Text(
            "Payload diterima:\n\n${c.lastPayload.value}",
            textAlign: TextAlign.center,
          );
        }),
      ),
    );
  }
}
