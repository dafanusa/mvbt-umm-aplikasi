import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/program_controller.dart';
import '../../login/controllers/login_controller.dart';
import '../../../models/program_model.dart';

class ProgramView extends GetView<ProgramController> {
  final Color maroon;
  ProgramView({super.key, required this.maroon});

  final LoginController loginC = Get.find<LoginController>();
  final RxString _selectedFilter = "Semua".obs;

  final List<String> statusOptions = ["Akan Datang", "Berlangsung", "Selesai"];

  Widget _buildFilterButton(
    String label,
    IconData icon,
    double fontSize,
    double paddingScale,
    double screenWidth,
  ) {
    return Obx(() {
      final bool selected = _selectedFilter.value == label;
      final bool isWideScreen = screenWidth > 900;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 8 : 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _selectedFilter.value = label,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(
              vertical: 10 * paddingScale,
              horizontal: isWideScreen ? 28 : 18,
            ),
            decoration: BoxDecoration(
              color: selected ? maroon : Colors.white,
              border: Border.all(
                color: selected ? maroon : Colors.grey.shade400,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: maroon.withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18 * paddingScale,
                  color: selected ? Colors.white : maroon,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : maroon,
                    fontSize: fontSize,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProgramCard(final ProgramModel program, double screenWidth) {
    final status = program.status;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 100),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.only(right: 40), // ⭐ FIX TABRAKAN ICON
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.title,
                  style: TextStyle(
                    color: maroon,
                    fontSize: screenWidth < 600 ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  program.description,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: screenWidth < 600 ? 13 : 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "📅 ${program.date}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      // Logika warna status
                      color: status == "Berlangsung"
                          ? Colors.green
                          : status == "Selesai"
                          ? Colors.grey
                          : status == "Akan Datang"
                          ? Colors
                                .blue // Status Akan Datang kita beri warna biru
                          : Colors
                                .orange, // Status lainnya (misal: NULL, EMPTY, atau typo)
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      // Tampilkan status dengan kapitalisasi yang baik untuk UI
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // EDIT & DELETE BUTTON ADMIN
        if (loginC.userRole.value == "admin")
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                  onPressed: () {
                    final TextEditingController titleC = TextEditingController(
                      text: program.title,
                    );
                    final TextEditingController descC = TextEditingController(
                      text: program.description,
                    );
                    final TextEditingController dateC = TextEditingController(
                      text: program.date,
                    );

                    final RxString selectedStatus = program.status.obs;

                    showDialog(
                      context: Get.context!,
                      builder: (_) => AlertDialog(
                        title: const Text("Edit Program"),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: titleC,
                                decoration: const InputDecoration(
                                  labelText: "Judul Program",
                                ),
                              ),
                              TextField(
                                controller: descC,
                                decoration: const InputDecoration(
                                  labelText: "Deskripsi",
                                ),
                              ),

                              // =====================
                              //       DATE PICKER
                              // =====================
                              TextField(
                                controller: dateC,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Tanggal",
                                  suffixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Color.fromARGB(255, 99, 0, 0),
                                  ),
                                ),
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: Get.context!,
                                    initialDate:
                                        DateTime.tryParse(program.date) ??
                                        DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    dateC.text = DateFormat(
                                      "yyyy-MM-dd",
                                    ).format(picked);
                                  }
                                },
                              ),

                              const SizedBox(height: 12),

                              // =====================
                              //       DROPDOWN STATUS
                              // =====================
                              Obx(
                                () => DropdownButtonFormField<String>(
                                  value: selectedStatus.value,
                                  items:
                                      ["Akan Datang", "Berlangsung", "Selesai"]
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (v) => selectedStatus.value = v!,
                                  decoration: const InputDecoration(
                                    labelText: "Status",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(Get.context!),
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final p = ProgramModel(
                                id: program.id, // WAJIB
                                title: titleC.text,
                                description: descC.text,
                                date: dateC.text,
                                status: selectedStatus.value,
                              );

                              await controller.updateProgram(p);

                              Navigator.pop(Get.context!);
                            },
                            child: const Text("Update"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // ... (Kode delete IconButton tidak berubah) ...
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    final confirm = await Get.dialog(
                      AlertDialog(
                        title: const Text("Konfirmasi Hapus"),
                        content: const Text(
                          "Apakah Anda yakin ingin menghapus program ini?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            child: const Text("Hapus"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await controller.deleteProgram(program.id);
                    }
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (Variabel screenWidth, fontSize, paddingScale tidak berubah) ...
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth < 400
        ? 12
        : screenWidth < 900
        ? 14
        : 16;
    final double paddingScale = screenWidth < 400
        ? 0.8
        : screenWidth < 900
        ? 1.0
        : 1.2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: maroon,
        automaticallyImplyLeading: false,
        title: const Text(
          "Program Kerja",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // ADD BUTTON HANYA UNTUK ADMIN
          Obx(() {
            if (loginC.userRole.value == "admin") {
              return IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  final TextEditingController titleC = TextEditingController();
                  final TextEditingController descC = TextEditingController();

                  final DateTime now = DateTime.now();
                  final TextEditingController dateC = TextEditingController(
                    text: DateFormat("yyyy-MM-dd").format(now),
                  );

                  final RxString selectedStatus = "Akan Datang".obs;

                  showDialog(
                    context: Get.context!,
                    builder: (_) => AlertDialog(
                      title: const Text("Tambah Program"),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: titleC,
                              decoration: const InputDecoration(
                                labelText: "Judul Program",
                              ),
                            ),
                            TextField(
                              controller: descC,
                              decoration: const InputDecoration(
                                labelText: "Deskripsi",
                              ),
                            ),

                            // =====================
                            //       DATE PICKER
                            // =====================
                            TextField(
                              controller: dateC,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "Tanggal",
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Color.fromARGB(255, 116, 0, 0),
                                ),
                              ),
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: Get.context!,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  dateC.text = DateFormat(
                                    "yyyy-MM-dd",
                                  ).format(picked);
                                }
                              },
                            ),

                            const SizedBox(height: 12),

                            // =====================
                            //      DROPDOWN STATUS
                            // =====================
                            Obx(
                              () => DropdownButtonFormField<String>(
                                value: selectedStatus.value,
                                items: ["Akan Datang", "Berlangsung", "Selesai"]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => selectedStatus.value = v!,
                                decoration: const InputDecoration(
                                  labelText: "Status",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(Get.context!),
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final p = ProgramModel(
                              id: 0, // ini tidak kepakai karena toJson tidak mengirim id
                              title: titleC.text,
                              description: descC.text,
                              date: dateC.text,
                              status: selectedStatus.value,
                            );

                            await controller.addProgram(p);

                            Navigator.pop(Get.context!);
                          },
                          child: const Text("Simpan"),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          }),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.getPrograms(),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ... (Kode LayoutBuilder tidak berubah) ...
            final double horizontalPadding = screenWidth < 500
                ? 12
                : screenWidth < 900
                ? 32
                : 80;

            return Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<ProgramModel> filtered = controller.programs.where((
                p,
              ) {
                if (_selectedFilter.value == "Semua") return true;
                if (_selectedFilter.value == "Akan Datang") {
                  return p.status == "Akan Datang";
                } else if (_selectedFilter.value == "Berlangsung") {
                  return p.status == "Berlangsung";
                } else if (_selectedFilter.value == "Selesai") {
                  return p.status == "Selesai";
                }
                return false;
              }).toList();

              return RefreshIndicator(
                onRefresh: () => controller.getPrograms(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ... (Header Box tidak berubah) ...
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: maroon,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Program Kerja",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Muhammadiyah Volleyball Team UMM\nKepengurusan Periode 2025 - 2026",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // FILTER BUTTONS (Tidak Berubah)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final bool isWide = constraints.maxWidth > 900;
                            final List<Widget> buttons = [
                              _buildFilterButton(
                                "Semua",
                                Icons.list_alt,
                                fontSize,
                                paddingScale,
                                screenWidth,
                              ),
                              _buildFilterButton(
                                "Akan Datang",
                                Icons.access_time,
                                fontSize,
                                paddingScale,
                                screenWidth,
                              ),
                              _buildFilterButton(
                                "Berlangsung",
                                Icons.play_circle_fill,
                                fontSize,
                                paddingScale,
                                screenWidth,
                              ),
                              _buildFilterButton(
                                "Selesai",
                                Icons.check_circle,
                                fontSize,
                                paddingScale,
                                screenWidth,
                              ),
                            ];

                            return isWide
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: buttons,
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: buttons),
                                  );
                          },
                        ),

                        const SizedBox(height: 16),

                        // GRID PROGRAM (Tidak Berubah, hanya filter yang sudah disesuaikan di atas)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double cardWidth;
                            if (screenWidth < 600) {
                              cardWidth = constraints.maxWidth;
                            } else if (screenWidth < 1000) {
                              cardWidth = (constraints.maxWidth - 24) / 2;
                            } else {
                              cardWidth = (constraints.maxWidth - 48) / 3;
                            }

                            return Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: filtered
                                  .map(
                                    (program) => SizedBox(
                                      width: cardWidth,
                                      child: _buildProgramCard(
                                        program,
                                        screenWidth,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
