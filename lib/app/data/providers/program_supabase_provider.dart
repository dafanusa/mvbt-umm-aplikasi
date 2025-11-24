import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/program_model.dart';

class ProgramSupabaseService {
  final supabase = Supabase.instance.client;
  final String table = "programs";

  // =====================================================
  // GET ALL PROGRAMS
  // =====================================================
  Future<List<ProgramModel>> fetchPrograms() async {
    final response = await supabase
        .from(table)
        .select()
        .order('id', ascending: false);

    return response.map((e) => ProgramModel.fromJson(e)).toList();
  }

  // =====================================================
  // INSERT PROGRAM
  // =====================================================
  Future<bool> addProgram(ProgramModel p) async {
    final data = {
      "title": p.title,
      "description": p.description,
      "status": p.status,
    };

    final result = await supabase.from(table).insert(data);

    return result.isNotEmpty;
  }

  // =====================================================
  // UPDATE PROGRAM
  // =====================================================
  Future<bool> updateProgram(ProgramModel p) async {
    final data = {
      "title": p.title,
      "description": p.description,
      "status": p.status,
      "updated_at": DateTime.now().toIso8601String(),
    };

    final result = await supabase
        .from(table)
        .update(data)
        .eq('id', p.id);

    return result.isNotEmpty;
  }

  // =====================================================
  // DELETE PROGRAM
  // =====================================================
  Future<bool> deleteProgram(int id) async {
    final result =
        await supabase.from(table).delete().eq('id', id);

    return result.isNotEmpty;
  }
}