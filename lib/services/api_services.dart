import '../app/models/program_model.dart';

abstract class ApiService {
  Future<Map<String, dynamic>> fetchProgramsWithStatus();

  Future<bool> addProgram(ProgramModel program);

  Future<bool> updateProgram(ProgramModel program);

  Future<bool> deleteProgram(int id);
}
