class ProgramModel {
  final int id;
  final String title;
  final String description;
  final String date; 
  final String status;

  ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
  });

  // ================================
  // FROM JSON (Supabase & API)
  // ================================
  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()) ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      date: json["date"] ?? "",
      status: json["status"] ?? "",
    );
  }

  // ================================
  // UPDATE / SEND FULL DATA
  // ================================
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "date": date,
      "status": status,
    };
  }

  // ================================
  // CREATE (INSERT ONLY)
  // id TIDAK BOLEH DIKIRIM
  // ================================
  Map<String, dynamic> toJsonCreate() {
    return {
      "title": title,
      "description": description,
      "date": date,
      "status": status,
    };
  }
}
