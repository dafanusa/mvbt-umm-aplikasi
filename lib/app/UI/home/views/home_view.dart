import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../../widgets/home_card.dart';

class HomeView extends GetView<HomeController> {
  final Color maroon;
  final String username;

  const HomeView({super.key, required this.maroon, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              _buildTodayScheduleCard(),
              const SizedBox(height: 25),
              _buildAnnouncementSection(),
              const SizedBox(height: 25),
              _buildLatestActivitiesSection(),
              const SizedBox(height: 30),
            ]),
          ),
        ],
      ),
    );
  }

  // ========================= HEADER =========================
  Widget _buildSliverHeader() {
    return SliverAppBar(
      toolbarHeight: 120,
      elevation: 0,
      backgroundColor: maroon,
      foregroundColor: Colors.white,
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18, top: 10, bottom: 10),
          child: GestureDetector(
            onTap: () {
              print("Logo di pojok kanan diklik!");
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset('assets/logomvbt.jpg', fit: BoxFit.contain),
            ),
          ),
        ),
      ],
    );
  }

  // ========================= JADWAL =========================
  Widget _buildTodayScheduleCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Card(
        color: maroon.withOpacity(0.9),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "📅 Jadwal Hari Ini",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Text(
                  controller.todaySchedule.value,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: controller.goToSchedule,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Lihat Semua Jadwal",
                    style: TextStyle(
                      color: Colors.white,
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

  // ========================= PENGUMUMAN =========================
  Widget _buildAnnouncementSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("📢 Pengumuman Penting"),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade300, width: 2),
            ),
            child: Obx(
              () => Text(
                controller.latestAnnouncement.value,
                style: TextStyle(color: Colors.orange[800], fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              print("Arahkan ke Menu Pengumuman");
            },
            child: const Text(
              "Lihat semua pengumuman >",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ========================= KEGIATAN TERBARU =========================
  Widget _buildLatestActivitiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            "🎯 Kegiatan Terbaru",
          ), 
          const SizedBox(height: 12),
          Obx(() {
            if (controller.events.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Belum ada kegiatan terbaru 😌",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
            }

            final int displayCount = controller.events.length > 3
                ? 3
                : controller.events.length;

            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: displayCount,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 24), // ✨ jarak antar kegiatan
              itemBuilder: (context, index) {
                final event = controller.events[index];
                final List<String> sampleImages = [
                  'assets/gallery1.jpg',
                  'assets/gallery2.jpg',
                  'assets/gallery3.jpg',
                ];
                final String imagePath =
                    sampleImages[index % sampleImages.length];

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
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${event.date} | ${event.time} di ${event.location}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
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

  // ========================= TITLE SECTION =========================
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
