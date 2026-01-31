import 'package:aplikasi_lispin/models/alat_models.dart';

class CartManager {
  static final List<AlatModel> _items = [];

  static List<AlatModel> get items => _items;

  static void add(AlatModel alat) {
    if (!_items.any((e) => e.idAlat == alat.idAlat)) {
      _items.add(alat);
    }
  }

  static void remove(int idAlat) {
    _items.removeWhere((e) => e.idAlat == idAlat);
  }

  static void clear() {
    _items.clear();
  }
}
