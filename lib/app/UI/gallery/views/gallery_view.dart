import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/gallery_controller.dart';

class GalleryView extends GetView<GalleryController> {
  final Color maroon;
  const GalleryView({super.key, required this.maroon});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bool isPortrait = mq.orientation == Orientation.portrait;
//k
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maroon,
        automaticallyImplyLeading: false,
        title: Text(
          'Gallery MVBT UMM',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double spacing = constraints.maxWidth * 0.02;
            final int crossAxisCount = constraints.maxWidth > 600
                ? 4
                : (isPortrait ? 2 : 3);
            return GetBuilder<GalleryController>(
              builder: (ctrl) {
                return FadeTransition(
                  opacity: ctrl.fade,
                  child: ScaleTransition(
                    scale: ctrl.scale,
                    child: GridView.builder(
                      padding: EdgeInsets.all(spacing),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final bool isZoomed =
                              ctrl.selectedIndex.value == index;

                          return GestureDetector(
                            onTap: () => ctrl.onImageTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                              transform: Matrix4.identity()
                                ..scale(isZoomed ? 1.1 : 1.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: isZoomed ? 12 : 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/gallery${(index % 5) + 1}.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
