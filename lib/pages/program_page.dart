import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProgramPage extends StatelessWidget {
  final Color maroon;
  ProgramPage({super.key, required this.maroon});

  // 🔹 Tombol Filter Responsif
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

  // 🔹 Card Program Dinamis
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
        mainAxisSize: MainAxisSize.min,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
        title: const Text(
          "Program Kerja",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double horizontalPadding = screenWidth < 500
                ? 12
                : screenWidth < 900
                ? 32
                : 80;

            return Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.programs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      "Belum ada data.\nTekan tombol refresh 🔄 di pojok kanan atas.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.fetchPrograms,
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
                        // Header
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

                        // 🔝 Tombol Filter Responsif
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 900;

                            // 🔹 kalau layar lebar (laptop), tombol filter dibentang penuh
                            if (isWide) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: _buildFilterButton(
                                      "Semua",
                                      Icons.list_alt,
                                      fontSize,
                                      paddingScale,
                                      screenWidth,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildFilterButton(
                                      "Akan Datang",
                                      Icons.access_time,
                                      fontSize,
                                      paddingScale,
                                      screenWidth,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildFilterButton(
                                      "Berlangsung",
                                      Icons.play_circle_fill,
                                      fontSize,
                                      paddingScale,
                                      screenWidth,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildFilterButton(
                                      "Selesai",
                                      Icons.check_circle,
                                      fontSize,
                                      paddingScale,
                                      screenWidth,
                                    ),
                                  ),
                                ],
                              );
                            }

                            // 🔹 kalau di HP, tetap bisa di-scroll horizontal
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
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
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // 🔹 Daftar Program (Wrap Layout)
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
                              children: filtered.map((program) {
                                return SizedBox(
                                  width: cardWidth,
                                  child: _buildProgramCard(
                                    program,
                                    screenWidth,
                                  ),
                                );
                              }).toList(),
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
