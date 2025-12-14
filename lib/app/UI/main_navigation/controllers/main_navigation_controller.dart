import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../notification/controllers/notification_controller.dart';

class MainNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final List<String> iconNames = [
    'home',
    'assignment',
    'calendar_month',
    'photo_album',
    'location',
    'person',
  ];

  final List<String> labels = const [
    "Home",
    "Program",
    "Jadwal",
    "Gallery",
    "Lokasi",
    "Profil",
  ];

  @override
  void onReady() {
    super.onReady();

    // Panggil consumePendingRoute setelah MainNavigation Controller (Halaman Utama)
    // siap dimuat. Ini memastikan tidak ada crash atau bentrok routing.

    try {
      final notificationController = Get.find<NotificationController>();
      notificationController.consumePendingRoute();
      print("✅ Navigasi notifikasi Terminated dicek.");
    } catch (e) {
      print("❌ Error saat mencoba menemukan NotificationController: $e");
    }
  }

  void changeTab(int index) => currentIndex.value = index;

  void onDoubleTapTab(int index) {
    if (currentIndex.value == index) {
    } else {
      changeTab(index);
    }
  }

  IconData getIconFromName(String name) {
    switch (name) {
      case 'home':
        return Icons.home;
      case 'assignment':
        return Icons.assignment;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'photo_album':
        return Icons.photo_album;
      case 'location':
        return Icons.location_on;
      case 'person':
        return Icons.person;
      default:
        return Icons.help_outline;
    }
  }
}
