import 'package:supabase_flutter/supabase_flutter.dart';
import '../app/models/program_model.dart';

class ProgramSupabaseService {
  final supabase = Supabase.instance.client;

  /// 🔹 GET ALL PROGRAM
  Future<List<ProgramModel>> getPrograms() async {
    final response = await supabase
        .from('programs')
        .select('*')
        .order('date', ascending: true);
    return (response as List<dynamic>)
        .map((json) => ProgramModel.fromJson(json))
        .toList();
  }

  /// 🔹 GET DETAIL PROGRAM BY ID
  Future<ProgramModel?> getProgramById(int id) async {
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
    final data = {
      'title': program.title,
      'description': program.description,
      'date': program.date,
      'status': program.status,
    };

    final response = await supabase.from('programs').insert(data).select();
    return response.isNotEmpty;
  }

  /// 🔹 UPDATE PROGRAM
  Future<bool> updateProgram(ProgramModel program) async {
    final data = {
      'title': program.title,
      'description': program.description,
      'date': program.date,
      'status': program.status,
    };
    final response = await supabase
        .from('programs')
        .update(data)
        .eq('id', program.id)
        .select();

    return response.isNotEmpty;
  }

  /// 🔹 DELETE PROGRAM
  Future<bool> deleteProgram(int id) async {
    final response = await supabase
        .from('programs')
        .delete()
        .eq('id', id)
        .select();

    return response.isNotEmpty;
  }
}
