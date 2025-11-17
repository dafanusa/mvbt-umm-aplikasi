import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // REGISTER
  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (res.user == null) return "Registrasi gagal";

      // simpan info user ke tabel 'users'
      await supabase.from('users').insert({
        'id': res.user!.id,
        'email': email,
        'name': name,
        'role': role,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // LOGIN
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

  // GET ROLE + DATA USER
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final data = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return data;
  }

  // LOGOUT
  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
