import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/views/home_view.dart';
import '../../gallery/views/gallery_view.dart';
import '../../profile/views/profile_view.dart';
import '../../program/views/program_view.dart';
import '../../jadwal/views/jadwal_view.dart';
import '../controllers/main_navigation_controller.dart';
import '../../location/views/location_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  final String username;
  final Color maroon;

  const MainNavigationView({
    super.key,
    required this.username,
    required this.maroon,
  });

  @override
  Widget build(BuildContext context) {
    final pages = [
      _wrapWithBottomPadding(HomeView(username: username, maroon: maroon)),
      _wrapWithBottomPadding(ProgramView(maroon: maroon)),
      _wrapWithBottomPadding(JadwalView(maroon: maroon)),
      _wrapWithBottomPadding(GalleryView(maroon: maroon)),
      _wrapWithBottomPadding(LocationView(maroon: maroon)),
      _wrapWithBottomPadding(ProfileView(username: username)),
    ];

    return Scaffold(
      extendBody: true,
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() => _buildFloatingNavBar()),
    );
  }

  Widget _wrapWithBottomPadding(Widget page) {
    return Padding(padding: const EdgeInsets.only(bottom: 90), child: page);
  }

  Widget _buildFloatingNavBar() {
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          height: 62,
          decoration: BoxDecoration(
            color: maroon,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 3,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(controller.iconNames.length, (i) {
              final isActive = controller.currentIndex.value == i;
              final IconData iconData = controller.getIconFromName(
                controller.iconNames[i],
              );
              return GestureDetector(
                onTap: () => controller.changeTab(i),
                onDoubleTap: () => controller.onDoubleTapTab(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: isActive ? 12 : 6,
                    vertical: isActive ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: isActive ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          iconData,
                          color: Colors.white,
                          size: isActive ? 30 : 26,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isActive ? 13 : 11,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        child: Text(controller.labels[i]),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
