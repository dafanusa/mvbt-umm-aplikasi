import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../../widgets/home_card.dart';
import '../../../core/theme/theme_controller.dart';

class HomeView extends GetView<HomeController> {
  final Color maroon;
  final String username;

  const HomeView({super.key, required this.maroon, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              _buildTodayScheduleCard(context),
              const SizedBox(height: 25),
              _buildAnnouncementSection(context),
              const SizedBox(height: 25),
              _buildLatestActivitiesSection(context),
              const SizedBox(height: 30),
            ]),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================
  Widget _buildSliverHeader(BuildContext context) {
    final theme = Theme.of(context);

    // warna header menyesuaikan theme
    final headerColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.primary.withOpacity(0.3)
        : maroon;

    return SliverAppBar(
      toolbarHeight: 120,
      elevation: 0,
      backgroundColor: headerColor,
      foregroundColor: theme.colorScheme.onPrimary,
      pinned: false,
      snap: false,
      floating: true,
      titleSpacing: 0.0,

      title: ScaleTransition(
        scale: controller.headerScale,
        child: Padding(
          padding: const EdgeInsets.only(left: 18, top: 10, bottom: 10),
          child: Text(
            "Selamat Datang, di Aplikasi MVBT Activity Manager $username",
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),

      actions: [
        // TOMBOL DARK MODE
        Obx(() {
          final themeC = Get.find<ThemeController>();
          return IconButton(
            icon: Icon(
              themeC.isDark.value ? Icons.dark_mode : Icons.light_mode,
              color: theme.colorScheme.onPrimary,
            ),
            onPressed: () => themeC.toggleTheme(),
          );
        }),

        // LOGO KANAN
        Padding(
          padding: const EdgeInsets.only(right: 18, top: 10, bottom: 10),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Image.asset('assets/logomvbt.jpg', fit: BoxFit.contain),
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // JADWAL HARI INI
  // =============================================================
  Widget _buildTodayScheduleCard(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Card(
        color: theme.colorScheme.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "📅 Jadwal Hari Ini",
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Obx(() => Text(
                    controller.todaySchedule.value,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 14,
                    ),
                  )),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: controller.goToSchedule,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: theme.colorScheme.onPrimary,
                  ),
                  label: Text(
                    "Lihat Semua Jadwal",
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // PENGUMUMAN
  // =============================================================
  Widget _buildAnnouncementSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "📢 Pengumuman Penting"),
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.secondary,
                width: 2,
              ),
            ),

            child: Obx(() => Text(
                  controller.latestAnnouncement.value,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // KEGIATAN TERBARU
  // =============================================================
  Widget _buildLatestActivitiesSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "🎯 Kegiatan Terbaru"),
          const SizedBox(height: 12),

          Obx(() {
            if (controller.events.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Belum ada kegiatan terbaru 😌",
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                ),
              );
            }

            final int displayCount =
                controller.events.length > 3 ? 3 : controller.events.length;

            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: displayCount,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final event = controller.events[index];
                final List<String> sampleImages = [
                  'assets/gallery1.jpg',
                  'assets/gallery2.jpg',
                  'assets/gallery3.jpg',
                ];
                final imagePath = sampleImages[index % sampleImages.length];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imagePath,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "${event.date} | ${event.time} di ${event.location}",
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // =============================================================
  // TITLE SECTION
  // =============================================================
  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onBackground,
      ),
    );
  }
}
