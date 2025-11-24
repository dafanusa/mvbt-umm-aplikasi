class ProgramModel {
  final int id;
  final String title;
  final String description;
  final String date;
  final String status;
  final bool isActive;

  ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isActive,
    required this.status,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    // Menentukan status otomatis berdasarkan isActive dan tanggal
    String computedStatus;
    if (json['is_active'] == true) {
      computedStatus = "Sedang Berlangsung";
    } else {
      computedStatus = _determineStatusFromDate(json['date']);
    }

    return ProgramModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tanpa Judul',
      description: json['description'] ?? 'Tidak ada deskripsi',
      date: json['date'] ?? 'Tanggal tidak tersedia',
      isActive: json['is_active'] ?? false,
      status: json['status'] ?? 'Tidak Diketahui',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'is_active': isActive,
      'status': status,
    };
  }

  /// 🔹 Fungsi bantu untuk menentukan status berdasarkan tanggal
  static String _determineStatusFromDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Tidak Diketahui";

    try {
      final eventDate = DateTime.parse(dateStr);
      final now = DateTime.now();

      if (eventDate.isAfter(now)) {
        return "Akan Datang";
      } else if (eventDate.isBefore(now)) {
        return "Selesai";
      } else {
        return "Sedang Berlangsung";
      }
    } catch (e) {
      return "Tidak Diketahui";
    }
  }
}