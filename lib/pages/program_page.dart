import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/program_controller.dart';
import '../models/program_model.dart';

class ProgramPage extends StatelessWidget {
  final Color maroon;
  ProgramPage({super.key, required this.maroon});

  final ProgramController controller = Get.put(ProgramController());
  final RxString _selectedFilter = "Semua".obs;

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

  Widget _buildProgramCard(ProgramModel program, double screenWidth) {
    final status = program.status;
    return Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: status == "Sedang Berlangsung"
                    ? Colors.green
                    : status == "Selesai"
                        ? Colors.grey
                        : Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
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
    );
  }

  Widget _buildApiSelector() {
    return Obx(() {
      return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: maroon,
          value: controller.apiMode.value,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white),
          items: const [
            DropdownMenuItem(value: "http", child: Text("HTTP")),
            DropdownMenuItem(value: "dio", child: Text("Dio")),
            DropdownMenuItem(value: "callback", child: Text("Callback")),
          ],
          onChanged: (value) {
            if (value != null) {
              controller.changeApiMode(value);
              if (value == "http") {
                controller.fetchProgramsHttpAsync();
              } else if (value == "dio") {
                controller.fetchProgramsDioAsync();
              } else {
                controller.fetchProgramsHttpCallbackChaining();
              }
            }
          },
        ),
      );
    });
  }

  Widget _buildLogPanel() {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(top: 10, bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🔍 Status Code: ${controller.statusCode.value}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              controller.statusMessage.value,
              style: TextStyle(
                color: controller.statusMessage.value.contains("Success")
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(),
            Text(
              "📄 Response Log:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              constraints: const BoxConstraints(maxHeight: 180),
              child: SingleChildScrollView(
                child: Text(
                  controller.responseLog.value.isEmpty
                      ? "(belum ada respons)"
                      : controller.responseLog.value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "monospace",
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize =
        screenWidth < 400 ? 12 : screenWidth < 900 ? 14 : 16;
    final double paddingScale =
        screenWidth < 400 ? 0.8 : screenWidth < 900 ? 1.0 : 1.2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: maroon,
        title: const Text(
          "Program Kerja",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          _buildApiSelector(),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              if (controller.apiMode.value == "http") {
                controller.fetchProgramsHttpAsync();
              } else if (controller.apiMode.value == "dio") {
                controller.fetchProgramsDioAsync();
              } else {
                controller.fetchProgramsHttpCallbackChaining();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double horizontalPadding =
                screenWidth < 500 ? 12 : screenWidth < 900 ? 32 : 80;

            return Obx(() {
              final mode = controller.apiMode.value;
              final isLoading = mode == "http"
                  ? controller.isLoadingHttp.value
                  : mode == "dio"
                      ? controller.isLoadingDio.value
                      : controller.isLoadingCallback.value;

              final data = mode == "http"
                  ? controller.httpProgramsAsync
                  : mode == "dio"
                      ? controller.dioProgramsAsync
                      : controller.httpProgramsCallback;

              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              List<ProgramModel> filtered = data.where((p) {
                if (_selectedFilter.value == "Semua") return true;
                if (_selectedFilter.value == "Akan Datang") {
                  return p.status == "Akan Datang";
                } else if (_selectedFilter.value == "Berlangsung") {
                  return p.status == "Sedang Berlangsung";
                } else if (_selectedFilter.value == "Selesai") {
                  return p.status == "Selesai";
                }
                return false;
              }).toList();

              return RefreshIndicator(
                onRefresh: () async {
                  if (controller.apiMode.value == "http") {
                    await controller.fetchProgramsHttpAsync();
                  } else if (controller.apiMode.value == "dio") {
                    await controller.fetchProgramsDioAsync();
                  } else {
                    await controller.fetchProgramsHttpCallbackChaining();
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
  
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
                                "Muhammadiyah Volleyball Team\nUniversitas Muhammadiyah Malang",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 900;
                            final buttons = [
                              _buildFilterButton("Semua", Icons.list_alt,
                                  fontSize, paddingScale, screenWidth),
                              _buildFilterButton("Akan Datang",
                                  Icons.access_time, fontSize, paddingScale, screenWidth),
                              _buildFilterButton("Berlangsung",
                                  Icons.play_circle_fill, fontSize, paddingScale, screenWidth),
                              _buildFilterButton("Selesai", Icons.check_circle,
                                  fontSize, paddingScale, screenWidth),
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
                        _buildLogPanel(),

                        const SizedBox(height: 16),

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
                                  .map((program) => SizedBox(
                                        width: cardWidth,
                                        child: _buildProgramCard(
                                            program, screenWidth),
                                      ))
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
