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
  List<DendaModel> filteredDendaList = [];
  bool loading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      final data = await service.getDenda();
      setState(() {
        dendaList = data;
        filteredDendaList = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void searchDenda(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDendaList = dendaList;
      } else {
        filteredDendaList = dendaList.where((denda) {
          final hariTerlambat = denda.hariTerlambat.toString();
          final totalDenda = denda.totalDenda.toString();
          return hariTerlambat.contains(query) || totalDenda.contains(query);
        }).toList();
      }
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
            /// SEARCH + ADD
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
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: 'search',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onChanged: searchDenda,
                          ),
                        ),
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
                        try {
                          final totalDenda = service.hitungTotalDenda(
                            res['hari_terlambat'],
                            res['denda_per_hari'],
                          );
                          
                          await service.tambahDenda(
                            DendaModel(
                              id: 0,
                              idPengembalian: res['id_pengembalian'],
                              hariTerlambat: res['hari_terlambat'],
                              dendaPerHari: res['denda_per_hari'],
                              totalDenda: totalDenda,
                            ),
                          );
                          await loadData();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Denda berhasil ditambahkan'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
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
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: filteredDendaList.isEmpty
                    ? const Center(child: Text("Belum ada denda"))
                    : ListView.separated(
                        itemCount: filteredDendaList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final d = filteredDendaList[index];
                          return DendaCard(
                            title: 'Denda #${d.id}',
                            subtitle:
                                '${d.hariTerlambat} hari × Rp${d.dendaPerHari}',
                            nominal: d.totalDenda,
                            onEdit: () async {
                              final res = await showDendaDialog(
                                context: context,
                                mode: "edit",
                                initialHariTerlambat:
                                    d.hariTerlambat.toString(),
                                initialDendaPerHari: d.dendaPerHari.toString(),
                                initialIdPengembalian: d.idPengembalian,
                              );
                              if (res != null) {
                                try {
                                  final totalDenda = service.hitungTotalDenda(
                                    res['hari_terlambat'],
                                    res['denda_per_hari'],
                                  );
                                  
                                  await service.editDenda(
                                    d.id,
                                    DendaModel(
                                      id: d.id,
                                      idPengembalian: res['id_pengembalian'],
                                      hariTerlambat: res['hari_terlambat'],
                                      dendaPerHari: res['denda_per_hari'],
                                      totalDenda: totalDenda,
                                    ),
                                  );
                                  await loadData();
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Denda berhasil diupdate'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              }
                            },
                            onDelete: () async {
                              final res = await showDendaDialog(
                                context: context,
                                mode: "delete",
                              );
                              if (res != null && res['delete'] == true) {
                                try {
                                  await service.hapusDenda(d.id);
                                  await loadData();
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Denda berhasil dihapus'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
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