// models/pengguna_models.dart

class PenggunaModel {
  final String idUser;
  final String nama;
  final String username;
  final String role;

  const PenggunaModel({
    required this.idUser,
    required this.nama,
    required this.username,
    required this.role,
  });

  factory PenggunaModel.fromMap(Map<String, dynamic> map) {
    return PenggunaModel(
      idUser: map['id_user'].toString(),
      nama: map['nama'] ?? '',
      username: map['username'] ?? '',
      role: map['role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_user': idUser,
      'nama': nama,
      'username': username,
      'role': role,
    };
  }
}