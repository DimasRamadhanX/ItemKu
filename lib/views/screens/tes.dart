import 'package:flutter/material.dart';
import '../../../services/barang_service.dart';
import '../../../models/barang_model.dart';

class TesScreen extends StatefulWidget {
  const TesScreen({super.key});

  @override
  State<TesScreen> createState() => _TesScreenState();
}

class _TesScreenState extends State<TesScreen> {
  int _counter = 0;
  final BarangService barangService = BarangService();
  List<Barang> allData = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _testSQLite() async {
    await barangService.addBarang(
      Barang(
        nama: 'Tes SQLite ($_counter)',
        jumlah: _counter,
        alamat: 'Jl. Test',
        deskripsi: 'Deskripsi $_counter',
      ),
    );
    await _loadData();
  }

  Future<void> _loadData() async {
    final data = await barangService.getAllBarang();
    setState(() {
      allData = data;
    });
  }

  Future<void> _hapusDatabase() async {
    await barangService.deleteDatabase();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Database berhasil dihapus')),
    );
    setState(() {
      allData.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tes SQLite'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _testSQLite,
              child: const Text('Test SQLite Insert'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _hapusDatabase,
              child: const Text('Hapus Database'),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              'Data Barang dari SQLite:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: allData.isEmpty
                  ? const Center(child: Text('Tidak ada data.'))
                  : ListView.builder(
                      itemCount: allData.length,
                      itemBuilder: (context, index) {
                        final item = allData[index];
                        return ListTile(
                          leading: Text('${item.id}'),
                          title: Text(item.nama),
                          subtitle: Text('Jumlah: ${item.jumlah}\nAlamat: ${item.alamat}'),
                          isThreeLine: true,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
