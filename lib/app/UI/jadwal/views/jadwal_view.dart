import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/jadwal_controller.dart';
import '../../login/controllers/login_controller.dart';
import '../../../core/values/app_colors.dart';
import '../../../models/jadwal_model.dart';

class JadwalView extends GetView<JadwalController> {
  final Color maroon;

  const JadwalView({Key? key, this.maroon = const Color(0xFF800000)})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginC = Get.find<LoginController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      floatingActionButton: Obx(() {
        return loginC.userRole.value == "admin"
            ? FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 122, 0, 0),
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () => _showAddDialog(context),
              )
            : const SizedBox();
      }),

      body: Column(
        children: [
          _header(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Obx(() => _calendar(context)),
                  const SizedBox(height: 16),
                  Obx(() => _filterButtons(context)),
                  const SizedBox(height: 16),
                  Obx(() => _eventList(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================ HEADER ============================
  Widget _header(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: top + 15, bottom: 15),
      color: const Color.fromARGB(255, 122, 0, 0),
      alignment: Alignment.center,
      child: const Text(
        "Jadwal Kegiatan 📅",
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================ CALENDAR ============================
  Widget _calendar(BuildContext context) {
    final theme = Theme.of(context);

    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: controller.focusedDay.value,
      selectedDayPredicate: (day) =>
          controller.selectedDay.value != null &&
          day.year == controller.selectedDay.value!.year &&
          day.month == controller.selectedDay.value!.month &&
          day.day == controller.selectedDay.value!.day,

      onDaySelected: (selected, focused) =>
          controller.onDaySelected(selected, focused),

      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onBackground,
          fontWeight: FontWeight.bold,
        ),
      ),

      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 102, 143),
          shape: BoxShape.circle,
        ),
      ),

      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, _) {
          if (controller.latihanDates.contains(date)) {
            return _dot(theme.colorScheme.primary);
          }
          if (controller.pertandinganDates.contains(date)) {
            return _dot(theme.colorScheme.secondary);
          }
          return null;
        },
      ),
    );
  }

  Widget _dot(Color c) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      ),
    );
  }

  // ============================ FILTER BUTTONS ============================
  Widget _filterButtons(BuildContext context) {
    final filters = ["Semua", "Latihan", "Pertandingan"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: filters.map((f) {
        final selected = controller.selectedFilter.value == f;

        return FilterChip(
          label: Text(
            f,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          selected: selected,
          onSelected: (_) => controller.setFilter(f),
          backgroundColor: const Color.fromARGB(255, 206, 206, 206),
          selectedColor: const Color.fromARGB(255, 122, 0, 0),

          checkmarkColor: Colors.white,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide.none,
          ),
        );
      }).toList(),
    );
  }

  // ============================ EVENT LIST ============================
  Widget _eventList(BuildContext context) {
    final theme = Theme.of(context);
    final items = controller.filteredEvents;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          "Tidak ada kegiatan pada tanggal ini.",
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      );
    }

    return Column(children: items.map((e) => _eventCard(context, e)).toList());
  }

  // ============================ EVENT CARD ============================
  Widget _eventCard(BuildContext context, JadwalModel e) {
    final theme = Theme.of(context);
    final loginC = Get.find<LoginController>();

    Color color = e.category == "Latihan"
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT INFO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.formatDate(e.date),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                e.time,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // ADMIN BUTTONS
          if (loginC.userRole.value == "admin")
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _showEditDialog(context, e),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => controller.deleteJadwal(e.id),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ============================ DIALOG FORM ============================
  void _showAddDialog(BuildContext context) {
    _showJadwalForm(context, isEdit: false);
  }

  void _showEditDialog(BuildContext context, JadwalModel item) {
    _showJadwalForm(context, isEdit: true, oldItem: item);
  }

  void _showJadwalForm(
    BuildContext context, {
    required bool isEdit,
    JadwalModel? oldItem,
  }) {
    final theme = Theme.of(context);

    final titleC = TextEditingController(text: oldItem?.title ?? "");
    final timeC = TextEditingController(text: oldItem?.time ?? "");
    final category = (oldItem?.category ?? "Latihan").obs;
    DateTime selectedDate = oldItem?.date ?? DateTime.now();

    Get.defaultDialog(
      title: isEdit ? "Edit Jadwal" : "Tambah Jadwal",
      backgroundColor: theme.colorScheme.surface,
      titleStyle: TextStyle(color: theme.colorScheme.onSurface),

      content: Column(
        children: [
          TextField(
            controller: titleC,
            decoration: InputDecoration(
              labelText: "Judul",
              labelStyle: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
          TextField(
            controller: timeC,
            decoration: InputDecoration(
              labelText: "Waktu",
              labelStyle: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2024),
                lastDate: DateTime(2030),
              );
              if (picked != null) selectedDate = picked;
            },
            child: const Text("Pilih Tanggal"),
          ),

          const SizedBox(height: 10),

          Obx(() {
            return DropdownButton<String>(
              value: category.value,
              items: [
                "Latihan",
                "Pertandingan",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => category.value = v!,
            );
          }),
        ],
      ),

      textConfirm: "Simpan",
      confirmTextColor: Colors.white,
      buttonColor: const Color.fromARGB(255, 122, 0, 0),

      textCancel: "Batal",
      cancelTextColor: theme.colorScheme.onSurface,

      onConfirm: () {
        if (isEdit) {
          // UPDATE
          controller.updateJadwal(
            JadwalModel(
              id: oldItem!.id,
              title: titleC.text,
              time: timeC.text,
              date: selectedDate,
              category: category.value,
            ),
          );
        } else {
          // ADD
          controller.addJadwal(
            JadwalModel(
              id: controller.nextId,
              title: titleC.text,
              time: timeC.text,
              date: selectedDate,
              category: category.value,
            ),
          );
        }

        Get.back();
      },
    );
  }
}
