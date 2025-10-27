import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/program_model.dart';

class ApiHttpService {
  static const String endpointPrograms =
      "https://api-mvbtaplikasi-nodejs.vercel.app/programs";

  Future<List<ProgramModel>> fetchProgramsAsync() async {
    final url = Uri.parse(endpointPrograms);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => ProgramModel.fromJson(e)).toList();
      } else {
        throw Exception("Server Error (HTTP): Status ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Koneksi HTTP Gagal: ${e.toString()}");
    }
  }

  // 2. HTTP | Callback Chaining
  Future<List<ProgramModel>> fetchProgramsCallbackChaining() {
    final url = Uri.parse(endpointPrograms);
    return http
        .get(url)
        .then((response) {
          if (response.statusCode == 200) {
            return json.decode(response.body) as List;
          } else {
            throw Exception(
              "Server Error (Callback): Status ${response.statusCode}",
            );
          }
        })
        .then((data) {
          return data.map((e) => ProgramModel.fromJson(e)).toList();
        })
        .catchError((error) {
          throw Exception("Callback Chaining Gagal: ${error.toString()}");
        });
  }
}
// }