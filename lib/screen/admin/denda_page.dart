import 'package:aplikasi_lispin/models/denda_models.dart';
import 'package:aplikasi_lispin/services/denda_services.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_lispin/screen/admin/denda_card.dart';
import 'package:aplikasi_lispin/screen/admin/tambah_denda_dialog.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';

class DendaPage extends StatefulWidget {
  const DendaPage({super.key});

  @override
  State<DendaPage> createState() => _DendaPageState();
}

class _DendaPageState extends State<DendaPage> {
  final DendaService service = DendaService();
  List<DendaModel> dendaList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    final data = await service.getDenda();
    setState(() {
      dendaList = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomSidebar(role: UserRole.admin),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Denda', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SEARCH + ADD (UI ASLI)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, size: 20, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('search', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 42,
                  width: 42,
                  child: ElevatedButton(
                    onPressed: () async {
                      final res = await showDendaDialog(
                        context: context,
                        mode: "add",
                      );
                      if (res != null) {
                        await service.tambahDenda(
                          DendaModel(
                            id: 0,
                            nama: res['nama'],
                            biaya: res['biaya'],
                          ),
                        );
                        await loadData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              'Daftar denda',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 16),

            if (loading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: dendaList.isEmpty
                    ? const Center(child: Text("Belum ada denda"))
                    : ListView.separated(
                        itemCount: dendaList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final d = dendaList[index];
                          return DendaCard(
                            title: d.nama,
                            nominal: d.biaya,
                            onEdit: () async {
                              final res = await showDendaDialog(
                                context: context,
                                mode: "edit",
                                initialName: d.nama,
                                initialNominal: d.biaya.toString(),
                              );
                              if (res != null) {
                                await service.editDenda(
                                  d.id,
                                  DendaModel(
                                    id: d.id,
                                    nama: res['nama'],
                                    biaya: res['biaya'],
                                  ),
                                );
                                await loadData();
                              }
                            },
                            onDelete: () async {
                              final res = await showDendaDialog(
                                context: context,
                                mode: "delete",
                              );
                              if (res != null && res['delete'] == true) {
                                await service.hapusDenda(d.id);
                                await loadData();
                              }
                            },
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
