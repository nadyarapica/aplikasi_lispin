class PeminjamanData {
  final String nama;
  final String tanggal;
  String status;

  PeminjamanData({
    required this.nama,
    required this.tanggal,
    required this.status,
  });
}

class PeminjamanManager {
  static final List<PeminjamanData> _items = [];

  static List<PeminjamanData> get items => _items;

  static void add(PeminjamanData data) {
    _items.add(data);
  }

  static void updateStatus(int index, String status) {
    _items[index].status = status;
  }
}
