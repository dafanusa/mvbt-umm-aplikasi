import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../services/local_notification_service.dart';
import '../controllers/jadwal_controller.dart';
import '../../login/controllers/login_controller.dart';
import '../../../models/jadwal_model.dart';

class JadwalView extends GetView<JadwalController> {
  const JadwalView({super.key, required Color maroon});

  @override
  Widget build(BuildContext context) {
    final loginC = Get.find<LoginController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

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
                  Obx(() => _calendar()),
                  const SizedBox(height: 16),
                  Obx(() => _filterButtons()),

                  // ================= ADMIN TEST NOTIFICATION =================
                  Obx(() {
                    if (loginC.userRole.value != "admin") {
                      return const SizedBox();
                    }

                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            LocalNotificationService.show(
                              title: "⏰ Reminder Latihan",
                              body: "Latihan akan dimulai sebentar lagi",
                              payload: {"type": "jadwal_test"},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              122,
                              0,
                              0,
                            ),
                          ),
                          child: const Text(
                            "TEST NOTIFIKASI (ADMIN)",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 16),
                  Obx(() => _eventList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
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

  // ================= CALENDAR =================
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

      onDaySelected: (selected, focused) =>
          controller.onDaySelected(selected, focused),

      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, _) {
          if (controller.latihanDates.contains(date)) {
            return _dot(Colors.blue);
          }
          if (controller.pertandinganDates.contains(date)) {
            return _dot(Colors.red);
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

  // ================= FILTER =================
  Widget _filterButtons() {
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
        );
      }).toList(),
    );
  }

  // ================= EVENT LIST =================
  Widget _eventList() {
    final items = controller.filteredEvents;

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text("Tidak ada kegiatan pada tanggal ini."),
      );
    }

    return Column(children: items.map((e) => _eventCard(e)).toList());
  }

  // ================= EVENT CARD =================
  Widget _eventCard(JadwalModel e) {
    final loginC = Get.find<LoginController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: e.category == "Latihan"
            ? const Color(0xFF0D47A1)
            : const Color(0xFF7A0000),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
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
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  "${e.jadwalTime.hour.toString().padLeft(2, '0')}:${e.jadwalTime.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          if (loginC.userRole.value == "admin")
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _showEditDialog(Get.context!, e),
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

  // ================= FORM =================
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
    final titleC = TextEditingController(text: oldItem?.title ?? "");
    final category = (oldItem?.category ?? "Latihan").obs;

    DateTime selectedDate = oldItem?.date ?? DateTime.now();
    TimeOfDay selectedTime = oldItem != null
        ? TimeOfDay.fromDateTime(oldItem.jadwalTime)
        : const TimeOfDay(hour: 19, minute: 0);

    Get.defaultDialog(
      title: isEdit ? "Edit Jadwal" : "Tambah Jadwal",

      content: Column(
        children: [
          TextField(
            controller: titleC,
            decoration: const InputDecoration(labelText: "Judul"),
          ),

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

          ElevatedButton(
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );
              if (picked != null) selectedTime = picked;
            },
            child: Text(
              "Pilih Jam: ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}",
            ),
          ),

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
      onConfirm: () {
        final jadwalTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        final model = JadwalModel(
          id: oldItem?.id ?? 0,
          title: titleC.text,
          date: selectedDate,
          jadwalTime: jadwalTime,
          time: '',
          category: category.value,
        );

        isEdit ? controller.updateJadwal(model) : controller.addJadwal(model);

        Get.back();
      },
    );
  }
}
