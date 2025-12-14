// lib/models/program_model.dart

class ProgramModel {
  final int id;
  final String title;
  final String description;
  final String date;
  final String status;
  // Kolom 'isActive' DIHAPUS karena tidak ada di database Supabase Anda.

  ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
  });

  // Constructor untuk membuat objek dari data JSON (dari Supabase)
  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      // isActive tidak ada di sini
    );
  }

  // Method untuk mengubah objek menjadi Map (untuk dikirim ke Supabase)
  Map<String, dynamic> toJson() {
    return {
      // id tidak perlu dikirim saat INSERT (auto-increment)
      // id: id,
      'title': title,
      'description': description,
      'date': date,
      'status': status,
      // 'is_active': isActive, // DIHAPUS
    };
  }

  // Method untuk objek update (biasanya id perlu)
  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'status': status,
      // 'is_active': isActive, // DIHAPUS
    };
  }
}
