import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final List<String> iconNames = [
    'home',
    'assignment',
    'calendar_month',
    'photo_album',
    'person',
  ];

  final List<String> labels = const [
    "Home",
    "Program",
    "Jadwal",
    "Gallery",
    "Profil",
  ];

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
      case 'person':
        return Icons.person;
      default:
        return Icons.help_outline;
    }
  }
}
