import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../../widgets/event_card.dart';

class HomeView extends GetView<HomeController> {
  final Color maroon;
  final String username;

  const HomeView({super.key, required this.maroon, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Beranda",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),
          ScaleTransition(
            scale: controller.headerScale,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: maroon,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang, $username 👋",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Jadwal kegiatan terbaru kamu ada di bawah 🔥",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              if (controller.events.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada kegiatan 😌",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: controller.events.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final event = controller.events[index];

                  return EventCard(
                    key: ValueKey("event_$index"),
                    item: event,
                    maroon: maroon,
                    onTap: () => controller.toggleExpand(index),
                    onEdit: () {
                      controller.editEvent(
                        index,
                        "${event.title} (Edit)",
                        event.date,
                        event.time,
                        event.location,
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: maroon,
        onPressed: controller.addEvent,
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}
