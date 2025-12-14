class StrukturOrganisasiModel {
  final int id;
  final String nama;
  final String jabatan;
  final String? fotoUrl;
  final int urutan;

  StrukturOrganisasiModel({
    required this.id,
    required this.nama,
    required this.jabatan,
    this.fotoUrl,
    required this.urutan,
  });

  factory StrukturOrganisasiModel.fromJson(Map<String, dynamic> json) {
    return StrukturOrganisasiModel(
      id: json['id'],
      nama: json['nama'],
      jabatan: json['jabatan'],
      fotoUrl: json['foto_url'],
      urutan: json['urutan'] ?? 0,
    );
  }

  // 🔹 UNTUK INSERT / UPDATE (TANPA ID)
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'jabatan': jabatan,
      'foto_url': fotoUrl,
      'urutan': urutan,
    };
  }
}
