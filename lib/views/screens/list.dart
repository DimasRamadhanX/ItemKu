
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/barang_model.dart';
import '../../services/barang_service.dart';
import '../components/barangcard.dart';
import '../components/search.dart';
import '../components/filterdropdown.dart';

import '../components/bottomnav.dart';
import '../components/customappbar.dart';

class ListBarangScreen extends StatefulWidget {
  const ListBarangScreen({super.key});

  @override
  State<ListBarangScreen> createState() => _ListBarangScreenState();
}

class _ListBarangScreenState extends State<ListBarangScreen> {
  final BarangService _barangService = BarangService();
  List<Barang> _barangList = [];
  SortOrder _sortOrder = SortOrder.az;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _barangService.getAllBarang();
    setState(() => _barangList = _sortBarang(data));
  }

  List<Barang> _sortBarang(List<Barang> list) {
    list.sort((a, b) => _sortOrder == SortOrder.az
        ? a.nama.compareTo(b.nama)
        : b.nama.compareTo(a.nama));
    return list;
  }

  void _onSearchResult(List<Barang> results) {
    setState(() => _barangList = _sortBarang(results));
  }

  void _onSortChanged(SortOrder newOrder) {
    setState(() {
      _sortOrder = newOrder;
      _barangList = _sortBarang(_barangList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Beranda'),
      body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: SearchBarWidget(onSearchResult: _onSearchResult),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: FilterDropdown(
                  currentOrder: _sortOrder,
                  onChanged: _onSortChanged,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _barangList.length,
            itemBuilder: (context, index) {
              final barang = _barangList[index];
              return BarangCard(
                barang: barang,
                onTap: () => context.go('/barang/${barang.id}'),
              );
            },
          ),
        ),
      ],
    ),
      floatingActionButton: FloatingActionButton(
      onPressed: () => context.go('/barang/tambah'),
      child: const Icon(Icons.add),
    ),
    bottomNavigationBar: const BottomNav(
      currentIndex: 1,
    ),
    );
  }
}
