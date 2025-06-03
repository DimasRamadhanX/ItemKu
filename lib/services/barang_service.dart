import '../models/barang_model.dart';
import '../utils/db_helper.dart';

class BarangService {
  Future<int> addBarang(Barang barang) async {
    return await DBHelper.insertBarang(barang);
  }

  Future<List<Barang>> getAllBarang() async {
    return await DBHelper.getAllBarang();
  }

  Future<int> updateBarang(Barang barang) async {
    return await DBHelper.updateBarang(barang);
  }

  Future<int> deleteBarang(int id) async {
    return await DBHelper.deleteBarang(id);
  }

  Future<void> deleteDatabase() async {
    await DBHelper.deleteDatabaseFile();
  }

  Future<Barang?> getBarangById(int id) async {
    final all = await DBHelper.getAllBarang();
    try {
      return all.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Barang>> getBarangTerbaru() async {
    final all = await DBHelper.getAllBarang();
    all.sort((a, b) => (b.tanggalDibuat ?? DateTime(0)).compareTo(a.tanggalDibuat ?? DateTime(0)));
    return all.take(5).toList();
  }

  Future<List<Barang>> getBarangPrioritas() async {
    final all = await DBHelper.getAllBarang();
    // modifikasi: urutkan berdasarkan flag isPriority terlebih dahulu, lalu jumlah
    all.sort((a, b) {
      if (b.isPriority && !a.isPriority) return 1;
      if (a.isPriority && !b.isPriority) return -1;
      return b.jumlah.compareTo(a.jumlah);
    });
    return all.take(5).toList();
  }
}
