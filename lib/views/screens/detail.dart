import 'package:flutter/material.dart';
import 'package:myitems/models/barang_model.dart';
import 'package:myitems/services/barang_service.dart';
import '../components/bottomnav.dart';
import '../components/customappbar.dart';

class DetailScreen extends StatefulWidget {
  final int id;

  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final BarangService _barangService = BarangService();
  Barang? barang;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBarang();
  }

  Future<void> _loadBarang() async {
    final result = await _barangService.getBarangById(widget.id);
    setState(() {
      barang = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (barang == null) {
      return const Scaffold(
        body: Center(child: Text('Barang tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Detail Barang'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${barang!.nama}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Alamat: ${barang!.alamat}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Jumlah: ${barang!.jumlah}', style: const TextStyle(fontSize: 16)),
            // Tambahkan detail lain sesuai model
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1)
    );
  }
}
