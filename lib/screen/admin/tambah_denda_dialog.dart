import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showDendaDialog({
  required BuildContext context,
  required String mode,
  String? initialName,
  String? initialNominal,
}) async {
  const orange = Color(0xFFFF9800);

  final nameController = TextEditingController(text: initialName ?? '');
  final nominalController =
      TextEditingController(text: initialNominal ?? '');

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
                _inputField("nama", nameController),
                const SizedBox(height: 12),
                _inputField("biaya", nominalController),
              ],
              if (mode == "delete")
                const Text(
                  "Anda yakin menghapus denda ini ?",
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
                          final nama = nameController.text.trim();
                          final biaya =
                              int.tryParse(nominalController.text.trim()) ?? 0;
                          Navigator.pop(context, {
                            'nama': nama,
                            'biaya': biaya,
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
      );
    },
  );
}

Widget _inputField(String hint, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade300,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
