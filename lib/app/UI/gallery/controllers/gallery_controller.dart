import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController fadeController;
  late AnimationController scaleController;
  late Animation<double> fade;
  late Animation<double> scale;

  RxInt selectedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fade = Tween<double>(begin: 0, end: 1).animate(fadeController);
    scale = Tween<double>(begin: 0.95, end: 1).animate(scaleController);

    fadeController.forward();
    scaleController.forward();
  }

  void onImageTap(int index) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
    } else {
      selectedIndex.value = index;
    }
  }

  @override
  void onClose() {
    fadeController.dispose();
    scaleController.dispose();
    super.onClose();
  }
}
