class DendaModel {
  final int id;
  final String nama;
  final int biaya;

  DendaModel({
    required this.id,
    required this.nama,
    required this.biaya,
  });

  factory DendaModel.fromJson(Map<String, dynamic> json) {
    return DendaModel(
      id: json['id'] as int,
      nama: json['nama'] as String,
      biaya: json['biaya'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'biaya': biaya,
    };
  }
}
