import 'package:flutter/material.dart';

Future<void> showDendaDialog({
  required BuildContext context,
  required String mode, // add | edit | delete
  String? initialName,
  String? initialNominal,
}) {
  final nameController = TextEditingController(text: initialName);
  final nominalController = TextEditingController(text: initialNominal);

  const orange = Color(0xFFFF9800);

  return showDialog(
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
                _label("nama"),
                _input(nameController, orange),
                const SizedBox(height: 12),
                _label("nominal"),
                _input(nominalController, orange,
                    keyboardType: TextInputType.number),
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
                      onPressed: () => Navigator.pop(context),
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
                        Navigator.pop(context);
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
