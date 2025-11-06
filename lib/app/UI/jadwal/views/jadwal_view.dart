import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/jadwal_controller.dart';

class JadwalView extends GetView<JadwalController> {
  final Color maroon;
  const JadwalView({super.key, required this.maroon});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔹 Header kotak, tapi responsif dan tidak nabrak atas
          _header(topPadding),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                return Column(
                  children: [
                    _calendar(),
                    const SizedBox(height: 16),
                    _filterButtons(),
                    const SizedBox(height: 16),
                    _eventList(),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(double topPadding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 15, // biar turun dikit dari notch / status bar
        bottom: 15,
      ),
      color: maroon,
      alignment: Alignment.center,
      child: const Text(
        "Jadwal Kegiatan 📅",
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _calendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: controller.focusedDay.value,
      selectedDayPredicate: (day) =>
          controller.selectedDay.value != null &&
          day.year == controller.selectedDay.value!.year &&
          day.month == controller.selectedDay.value!.month &&
          day.day == controller.selectedDay.value!.day,
      onDaySelected: (selected, focused) {
        controller.onDaySelected(selected, focused);
      },
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, _) {
          if (controller.latihanDates.contains(date)) {
            return _dot(const Color.fromARGB(255, 0, 112, 4));
          }
          if (controller.pertandinganDates.contains(date)) {
            return _dot(const Color(0xFF0D47A1));
          }
          return null;
        },
      ),
    );
  }

  Widget _dot(Color color) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  Widget _filterButtons() {
    List<String> filters = ["Semua", "Latihan", "Pertandingan"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: filters.map((f) {
        final selected = controller.selectedFilter.value == f;
        return FilterChip(
          label: Text(
            f,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          selected: selected,
          onSelected: (_) => controller.setFilter(f),
          selectedColor: maroon,
          backgroundColor: Colors.grey[200],
        );
      }).toList(),
    );
  }

  Widget _eventList() {
    final filtered = controller.filteredEvents;

    if (filtered.isEmpty) {
      return const Text(
        "Tidak ada kegiatan pada tanggal ini.",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      children: filtered
          .map(
            (e) => _eventCard(
              e.title,
              controller.formatDate(e.date),
              e.time,
              e.category,
            ),
          )
          .toList(),
    );
  }

  Widget _eventCard(String title, String date, String time, String cat) {
    Color color = cat == "Latihan"
        ? const Color.fromARGB(255, 0, 112, 4)
        : const Color(0xFF0D47A1);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
