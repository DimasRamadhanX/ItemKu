import 'package:flutter/material.dart';
import 'services/barang_service.dart';
import 'models/barang_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final BarangService barangService = BarangService();
  List<Barang> allData = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Fungsi untuk mengetes SQLite
  Future<void> _testSQLite() async {
    final id = await barangService.addBarang(
      Barang(
        nama: 'Tes SQLite ($_counter)',
        jumlah: _counter,
        alamat: 'Jl. Test',
        deskripsi: 'Deskripsi $_counter',
      ),
    );
    print('Data berhasil ditambahkan dengan ID: $id');

    await _loadData();
  }

  Future<void> _loadData() async {
    final data = await barangService.getAllBarang();
    setState(() {
      allData = data;
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
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
