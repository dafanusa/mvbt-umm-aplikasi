import 'package:supabase_flutter/supabase_flutter.dart';
import '../app/models/program_model.dart';

class ProgramSupabaseService {
  final supabase = Supabase.instance.client;
  final String table = "programs";

  // =====================================================
  // CREATE (INSERT)
  // =====================================================
  Future<bool> addProgram(ProgramModel p) async {
    try {
      await supabase.from(table).insert(p.toJsonCreate());
      return true;
    } catch (e) {
      print("Supabase Add Error: $e");
      return false;
    }
  }

  // =====================================================
  // UPDATE
  // =====================================================
  Future<bool> updateProgram(ProgramModel p) async {
    try {
      await supabase
          .from(table)
          .update(p.toJson()) // toJson: mengirim semua kolom kecuali id
          .eq("id", p.id);

      return true;
    } catch (e) {
      print("Supabase Update Error: $e");
      return false;
    }
  }

  // =====================================================
  // DELETE
  // =====================================================
  Future<bool> deleteProgram(int id) async {
    try {
      await supabase.from(table).delete().eq("id", id);
      return true;
    } catch (e) {
      print("Supabase Delete Error: $e");
      return false;
    }
  }

  // =====================================================
  // READ ALL
  // =====================================================
  Future<List<ProgramModel>> getPrograms() async {
    try {
      final data = await supabase.from(table).select();

      return (data as List)
          .map<ProgramModel>((e) => ProgramModel.fromJson(e))
          .toList();

    } catch (e) {
      print("Supabase Get Error: $e");
      return [];
    }
  }
}