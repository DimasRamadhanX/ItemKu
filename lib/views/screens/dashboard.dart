import 'package:flutter/material.dart';
import 'package:myitems/models/barang_model.dart';
import 'package:myitems/services/barang_service.dart';
import '../components/bottomnav.dart';
import '../components/customappbar.dart';
import '../components/carddash.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BarangService _barangService = BarangService();
  int totalBarang = 0;
  List<Barang> barangTerbaru = [];
  List<Barang> barangPrioritas = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final count = await _barangService.countBarang();
    final terbaru = await _barangService.getBarangTerbaru();
    final prioritas = await _barangService.getBarangPrioritas();

    setState(() {
      totalBarang = count;
      barangTerbaru = terbaru;
      barangPrioritas = prioritas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Beranda'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Card Total Barang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(
                    '$totalBarang',
                    style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const Text('Pencatatan Barang', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bagian Barang Terbaru
            const Text('Baru Ditambahkan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: barangTerbaru.length,
                itemBuilder: (context, index) {
                  final barang = barangTerbaru[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CardDash(
                      barang: barang
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Bagian Barang Prioritas
            const Text('Prioritas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: barangPrioritas.length,
                itemBuilder: (context, index) {
                  final barang = barangPrioritas[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CardDash(
                      barang: barang
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
