import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class JadwalPage extends StatefulWidget {
  final Color maroon;

  const JadwalPage({super.key, required this.maroon});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedFilter = "Semua";

  // 🔹 Data semua event
  final List<Map<String, dynamic>> _events = [
    {
      "title": "Latihan Teknik",
      "date": DateTime(2025, 9, 17),
      "time": "20.00 WIB",
      "category": "Latihan",
    },
    {
      "title": "Latihan Fisik",
      "date": DateTime(2025, 9, 22),
      "time": "20.00 WIB",
      "category": "Latihan",
    },
    {
      "title": "Latihan Passing",
      "date": DateTime(2025, 9, 30),
      "time": "20.00 WIB",
      "category": "Latihan",
    },
    {
      "title": "FunMatch bersama UM",
      "date": DateTime(2025, 10, 1),
      "time": "19.00 WIB",
      "category": "Pertandingan",
    },
  ];


  List<Map<String, dynamic>> _getFilteredEvents() {
    return _events.where((event) {
      final sameDay = _selectedDay == null
          ? true
          : event["date"].year == _selectedDay!.year &&
                event["date"].month == _selectedDay!.month &&
                event["date"].day == _selectedDay!.day;
      final matchesFilter =
          _selectedFilter == "Semua" || event["category"] == _selectedFilter;
      return sameDay && matchesFilter;
    }).toList();
  }

  List<DateTime> get _latihanDates => _events
      .where((e) => e["category"] == "Latihan")
      .map<DateTime>((e) => e["date"])
      .toList();

  List<DateTime> get _pertandinganDates => _events
      .where((e) => e["category"] == "Pertandingan")
      .map<DateTime>((e) => e["date"])
      .toList();


  Widget _buildHeader(String title) {
    return Container(
      width: double.infinity,
      color: widget.maroon, 
      padding: const EdgeInsets.symmetric(vertical: 15), 
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            // Tambahkan letterSpacing agar font terlihat tebal/berat
            letterSpacing: 1.2, 
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _getFilteredEvents();

    return Scaffold(
      backgroundColor: Colors.white,
      // ⚠️ Hapus SafeArea di sini, pindah ke dalam SingleChildScrollView
      body: Column( // Ganti SafeArea(child: SingleChildScrollView) dengan Column(children: [Header, SingleChildScrollView])
        children: [
          // 1. Panggil Header yang Baru
          _buildHeader("Jadwal Kegiatan"), 
          
          // 2. Sisa konten Jadwal (Kalender, Filter, List)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Header LAMA Dihapus/Diganti dengan _buildHeader di atas
                  // Container lama yang panjang Dihapus dari sini

                  const SizedBox(height: 16),

                  // 🔹 Kalender
                  TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: widget.maroon.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: widget.maroon,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(shape: BoxShape.circle),
                    ),
                    // 🔹 Tampilkan marker event warna berbeda
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (_latihanDates.contains(date)) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 0, 112, 4),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        } else if (_pertandinganDates.contains(date)) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Filter kategori (responsive)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFilterChip("Semua"),
                      _buildFilterChip("Latihan"),
                      _buildFilterChip("Pertandingan"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Daftar jadwal
                  if (filteredEvents.isEmpty)
                    const Center(
                      child: Text(
                        "Tidak ada kegiatan pada tanggal ini.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    Column(
                      children: filteredEvents
                          .map(
                            (e) => _buildJadwalItem(
                              e["title"],
                              _formatDate(e["date"]),
                              e["time"],
                              e["category"],
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 FilterChip widget
  Widget _buildFilterChip(String label) {
    final bool selected = _selectedFilter == label;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: selected,
      onSelected: (_) => setState(() => _selectedFilter = label),
      selectedColor: widget.maroon,
      backgroundColor: Colors.grey[200],
    );
  }

  // 🔹 Item jadwal
  Widget _buildJadwalItem(
    String title,
    String date,
    String time,
    String category,
  ) {
    final Color color = category == "Latihan"
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

  // 🔹 Format tanggal jadi string
  String _formatDate(DateTime date) {
    const bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return "${_getNamaHari(date.weekday)}, ${date.day} ${bulan[date.month - 1]} ${date.year}";
  }

  String _getNamaHari(int day) {
    switch (day) {
      case 1:
        return "Senin";
      case 2:
        return "Selasa";
      case 3:
        return "Rabu";
      case 4:
        return "Kamis";
      case 5:
        return "Jumat";
      case 6:
        return "Sabtu";
      case 7:
        return "Minggu";
      default:
        return "";
    }
  }
}