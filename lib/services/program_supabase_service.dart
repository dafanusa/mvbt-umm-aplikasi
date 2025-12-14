import 'package:supabase_flutter/supabase_flutter.dart';
import '../app/models/program_model.dart';

class ProgramSupabaseService {
  final supabase = Supabase.instance.client;

  /// 🔹 GET ALL PROGRAM
  Future<List<ProgramModel>> getPrograms() async {
    // Pastikan select('*') berjalan lancar karena Model sudah disesuaikan
    // untuk mengabaikan kolom is_active yang tidak ada di DB.
    final response = await supabase
        .from('programs')
        .select('*')
        // Ganti order 'id' dengan 'date' agar urutan lebih logis untuk program kerja
        .order('date', ascending: true);

    // Casting response ke List<dynamic> lebih aman sebelum mapping
    return (response as List<dynamic>)
        .map((json) => ProgramModel.fromJson(json))
        .toList();
  }

  /// 🔹 GET DETAIL PROGRAM BY ID
  Future<ProgramModel?> getProgramById(int id) async {
    // select() dan eq() tidak perlu perubahan
    final response = await supabase
        .from('programs')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return ProgramModel.fromJson(response);
  }

  /// 🔹 CREATE PROGRAM
  Future<bool> createProgram(ProgramModel program) async {
    // *** PERUBAHAN UTAMA: HAPUS 'is_active' dari data yang akan di-INSERT ***
    final data = {
      'title': program.title,
      'description': program.description,
      'date': program.date,
      // 'is_active': program.isActive, // DIHAPUS karena tidak ada di DB
      'status': program.status,
    };

    // Supabase insert akan mengembalikan data yang di-insert jika berhasil,
    // jika gagal akan melempar error. Kita bisa check apakah ada data yang kembali (data yang di-insert)
    final response = await supabase.from('programs').insert(data).select();

    // Periksa apakah response adalah list yang tidak kosong
    return response.isNotEmpty;
  }

  /// 🔹 UPDATE PROGRAM
  Future<bool> updateProgram(ProgramModel program) async {
    // *** PERUBAHAN UTAMA: HAPUS 'is_active' dari data yang akan di-UPDATE ***
    final data = {
      'title': program.title,
      'description': program.description,
      'date': program.date,
      // 'is_active': program.isActive, // DIHAPUS karena tidak ada di DB
      'status': program.status,
    };

    // Tambahkan .select() untuk memastikan operasi berhasil dan mengembalikan data
    final response = await supabase
        .from('programs')
        .update(data)
        .eq('id', program.id)
        .select();

    return response.isNotEmpty;
  }

  /// 🔹 DELETE PROGRAM
  Future<bool> deleteProgram(int id) async {
    // Tambahkan .select() untuk memastikan operasi berhasil dan mengembalikan data
    final response = await supabase
        .from('programs')
        .delete()
        .eq('id', id)
        .select();

    return response.isNotEmpty;
  }
}
