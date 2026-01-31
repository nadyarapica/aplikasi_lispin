import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showDendaDialog({
  required BuildContext context,
  required String mode, // add | edit | delete
  String? initialIdPengembalian,
  String? initialHariTerlambat,
  String? initialDendaPerHari,
  String? initialTotalDenda, required String initialName, required String initialNominal,
}) {
  final idPengembalianController = TextEditingController(text: initialIdPengembalian);
  final hariTerlambatController = TextEditingController(text: initialHariTerlambat);
  final dendaPerHariController = TextEditingController(text: initialDendaPerHari);
  final totalDendaController = TextEditingController(text: initialTotalDenda);

  const orange = Color(0xFFFF9800);

  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mode == "add"
                    ? "Tambah denda"
                    : mode == "edit"
                        ? "Edit denda"
                        : "Hapus denda",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              if (mode != "delete") ...[
                _label("ID Pengembalian"),
                _input(idPengembalianController, orange, keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                _label("Hari Terlambat"),
                _input(hariTerlambatController, orange, keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                _label("Denda Per Hari"),
                _input(dendaPerHariController, orange, keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                _label("Total Denda"),
                _input(totalDendaController, orange, keyboardType: TextInputType.number),
              ],

              if (mode == "delete")
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Apakah kamu yakin ingin menghapus denda ini?",
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, null),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: orange),
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
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
                          Navigator.pop(context, {'confirmed': true});
                        } else {
                          // Validasi input
                          if (idPengembalianController.text.isEmpty ||
                              hariTerlambatController.text.isEmpty ||
                              dendaPerHariController.text.isEmpty ||
                              totalDendaController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Semua field harus diisi!'),
                              ),
                            );
                            return;
                          }

                          try {
                            final result = {
                              'id_pengembalian': int.parse(idPengembalianController.text),
                              'hari_terlambat': int.parse(hariTerlambatController.text),
                              'denda_per_hari': int.parse(dendaPerHariController.text),
                              'total_denda': int.parse(totalDendaController.text),
                            };
                            Navigator.pop(context, result);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Input harus berupa angka!'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        mode == "delete" ? "Hapus" : "Simpan",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _label(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(text),
  );
}

Widget _input(
  TextEditingController controller,
  Color color, {
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: color),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: color),
      ),
    ),
  );
}