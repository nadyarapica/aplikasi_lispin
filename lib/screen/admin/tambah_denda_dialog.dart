// screen/admin/tambah_denda_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>?> showDendaDialog({
  required BuildContext context,
  required String mode,
  required List<Map<String, dynamic>> pengembalianList,
  String? initialHariTerlambat,
  String? initialDendaPerHari,
  int? initialIdPengembalian,
}) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _DendaDialogWidget(
      mode: mode,
      pengembalianList: pengembalianList,
      initialHariTerlambat: initialHariTerlambat,
      initialDendaPerHari: initialDendaPerHari,
      initialIdPengembalian: initialIdPengembalian,
    ),
  );
}

class _DendaDialogWidget extends StatefulWidget {
  final String mode;
  final List<Map<String, dynamic>> pengembalianList;
  final String? initialHariTerlambat;
  final String? initialDendaPerHari;
  final int? initialIdPengembalian;

  const _DendaDialogWidget({
    required this.mode,
    required this.pengembalianList,
    this.initialHariTerlambat,
    this.initialDendaPerHari,
    this.initialIdPengembalian,
  });

  @override
  State<_DendaDialogWidget> createState() => __DendaDialogWidgetState();
}

class __DendaDialogWidgetState extends State<_DendaDialogWidget> {
  static const Color _orange = Color(0xFFFF9800);

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dendaPerHariCtrl;
  late final TextEditingController _tanggalCtrl;

  int? _selectedIdPengembalian;

  int _previewTotal = 0;

  DateTime? _selectedDate;
  DateTime? _tanggalPengembalian;

  @override
  void initState() {
    super.initState();

    _dendaPerHariCtrl = TextEditingController(
      text: widget.initialDendaPerHari ?? '',
    );
    _tanggalCtrl = TextEditingController();

    _selectedDate = DateTime.now();
    _tanggalCtrl.text = _formatTanggal(_selectedDate!);

    if (widget.initialIdPengembalian != null) {
      final ada = widget.pengembalianList.any(
        (p) => p['id_pengembalian'] == widget.initialIdPengembalian,
      );
      _selectedIdPengembalian =
          ada ? widget.initialIdPengembalian : null;
    }

    _recalcPreview();
    _dendaPerHariCtrl.addListener(_recalcPreview);
  }

  @override
  void dispose() {
    _dendaPerHariCtrl.dispose();
    _tanggalCtrl.dispose();
    super.dispose();
  }

  void _recalcPreview() {
    int hariTerlambat = 0;
    if (_selectedDate != null && _tanggalPengembalian != null) {
      final selisih =
          _selectedDate!.difference(_tanggalPengembalian!).inDays;
      hariTerlambat = selisih > 0 ? selisih : 0;
    }

    final d = int.tryParse(_dendaPerHariCtrl.text.trim()) ?? 0;

    if (mounted) {
      setState(() {
        _previewTotal = hariTerlambat * d;
      });
    }
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _tanggalPengembalian ?? DateTime.now().subtract(const Duration(days: 7)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Seharusnya Kembali',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _orange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _tanggalPengembalian = picked;
        _selectedDate = DateTime.now();
        _tanggalCtrl.text = _formatTanggal(picked);
        _recalcPreview();
      });
    }
  }

  void _onSimpan() {
    if (widget.mode == 'delete') {
      Navigator.pop(context, {'delete': true});
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    int hariTerlambat = 0;
    if (_selectedDate != null && _tanggalPengembalian != null) {
      final selisih =
          _selectedDate!.difference(_tanggalPengembalian!).inDays;
      hariTerlambat = selisih > 0 ? selisih : 0;
    }

    final dendaPerHari =
        int.parse(_dendaPerHariCtrl.text.trim());

    final totalDenda = hariTerlambat * dendaPerHari;

    Navigator.pop(context, {
      'id_pengembalian': _selectedIdPengembalian,
      'hari_terlambat': hariTerlambat,
      'denda_per_hari': dendaPerHari,
      'total_denda': totalDenda, // ✅ DITAMBAHKAN
      'tanggal_pengembalian':
          _tanggalPengembalian?.toIso8601String().split('T')[0],
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDelete = widget.mode == 'delete';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isDelete
                      ? 'Hapus Denda'
                      : widget.mode == 'edit'
                          ? 'Edit Denda'
                          : 'Tambah Denda',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),

                if (isDelete) ...[
                  const Icon(Icons.warning_amber_rounded,
                      size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  const Text(
                    'Anda yakin ingin menghapus denda ini?\n'
                    'Tindakan ini tidak dapat dibatalkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                ],

                if (!isDelete) ...[
                  TextFormField(
                    controller: _tanggalCtrl,
                    readOnly: true,
                    decoration:
                        _fieldDecoration('Tanggal Seharusnya Kembali')
                            .copyWith(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: _orange),
                        onPressed: _pilihTanggal,
                      ),
                    ),
                    onTap: _pilihTanggal,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Tanggal wajib dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _dendaPerHariCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration:
                        _fieldDecoration('Denda Per Hari (Rp)'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Denda per hari wajib diisi';
                      }
                      final parsed = int.tryParse(value.trim());
                      if (parsed == null || parsed <= 0) {
                        return 'Harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  if (_tanggalPengembalian != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hari Terlambat (otomatis)',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${_selectedDate != null && _tanggalPengembalian != null ? (_selectedDate!.difference(_tanggalPengembalian!).inDays > 0 ? _selectedDate!.difference(_tanggalPengembalian!).inDays : 0) : 0} hari',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_tanggalPengembalian != null)
                    const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.orange.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Denda (otomatis)',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Rp ${_formatAngka(_previewTotal)}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          side:
                              const BorderSide(color: _orange),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style:
                              TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSimpan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDelete
                              ? Colors.red.shade400
                              : _orange,
                          minimumSize: const Size(0, 44),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          isDelete ? 'Hapus' : 'Simpan',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:
            const BorderSide(color: Color(0xFFFF9800), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:
            const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:
            const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

String _formatAngka(int angka) {
  return angka.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  );
}

String _formatTanggal(DateTime tanggal) {
  final months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  return '${tanggal.day} ${months[tanggal.month - 1]} ${tanggal.year}';
}
