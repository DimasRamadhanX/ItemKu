import '../models/barang_model.dart';
import '../utils/db_helper.dart';

class BarangService {
  final db = DatabaseHelper.instance;

  Future<List<Barang>> getAllBarang() async {
    return await db.getAllBarang();
  }

  Future<int> addBarang(Barang barang) async {
    return await db.insertBarang(barang);
  }

  Future<Barang?> getBarangById(int id) async {
    return await db.getBarangById(id);
  }

  Future<int> updateBarang(Barang barang) async {
    return await db.updateBarang(barang);
  }

  Future<int> deleteBarang(int id) async {
    return await db.deleteBarang(id);
  }

  Future<List<Barang>> getBarangTerbaru() async {
    final all = await db.getAllBarang();
    return all.take(5).toList();
  }

  Future<List<Barang>> getBarangPrioritas() async {
    final all = await db.getAllBarang();
    all.sort((a, b) => b.jumlah.compareTo(a.jumlah));
    return all.take(5).toList();
  }
}
