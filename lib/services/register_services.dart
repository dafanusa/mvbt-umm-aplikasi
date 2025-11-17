import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterService {
  final supabase = Supabase.instance.client;

  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      // 1. Membuat user auth
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user == null) {
        return "Gagal membuat akun auth";
      }

      // 2. Simpan ke tabel public.users
      await supabase.from("users").insert({
        "id": user.id,
        "name": name,
        "role": role,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    return await supabase
        .from("users")
        .select()
        .eq("id", user.id)
        .maybeSingle();
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
