import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showDendaDialog({
  required BuildContext context,
  required String mode,
  String? initialHariTerlambat,
  String? initialDendaPerHari,
  int? initialIdPengembalian,
}) async {
  const orange = Color(0xFFFF9800);

  final hariTerlambatController =
      TextEditingController(text: initialHariTerlambat ?? '');
  final dendaPerHariController =
      TextEditingController(text: initialDendaPerHari ?? '');
  final idPengembalianController =
      TextEditingController(text: initialIdPengembalian?.toString() ?? '');

  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mode == "delete"
                      ? "Hapus"
                      : mode == "edit"
                          ? "Edit denda"
                          : "Tambah denda",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (mode != "delete") ...[
                  _inputField(
                    "ID Pengembalian (opsional)",
                    idPengembalianController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    "Hari Terlambat",
                    hariTerlambatController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    "Denda Per Hari",
                    dendaPerHariController,
                    keyboardType: TextInputType.number,
                  ),
                ],
                if (mode == "delete")
                  const Text(
                    "Anda yakin menghapus denda ini?",
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (mode == "delete") {
                            Navigator.pop(context, {'delete': true});
                          } else {
                            final idPengembalianText =
                                idPengembalianController.text.trim();
                            final hariTerlambat = int.tryParse(
                                    hariTerlambatController.text.trim()) ??
                                0;
                            final dendaPerHari = int.tryParse(
                                    dendaPerHariController.text.trim()) ??
                                0;

                            Navigator.pop(context, {
                              'id_pengembalian': idPengembalianText.isEmpty
                                  ? null
                                  : int.tryParse(idPengembalianText),
                              'hari_terlambat': hariTerlambat,
                              'denda_per_hari': dendaPerHari,
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _inputField(
  String hint,
  TextEditingController controller, {
  TextInputType? keyboardType,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade300,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}