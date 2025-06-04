import '../models/barang_model.dart';
import '../utils/db_helper.dart';

class BarangService {
  Future<int> addBarang(Barang barang) async {
    try {
      return await DBHelper.insertBarang(barang);
    } catch (e) {
      throw Exception('Gagal menambahkan barang: $e');
    }
  }

  Future<List<Barang>> getAllBarang() async {
    try {
      return await DBHelper.getAllBarang();
    } catch (e) {
      throw Exception('Gagal mengambil data barang: $e');
    }
  }

  Future<int> updateBarang(Barang barang) async {
    try {
      return await DBHelper.updateBarang(barang);
    } catch (e) {
      throw Exception('Gagal memperbarui barang: $e');
    }
  }

  Future<int> deleteBarang(int id) async {
    try {
      return await DBHelper.deleteBarang(id);
    } catch (e) {
      throw Exception('Gagal menghapus barang: $e');
    }
  }

  Future<void> deleteDatabase() async {
    try {
      await DBHelper.deleteDatabaseFile();
    } catch (e) {
      throw Exception('Gagal menghapus database: $e');
    }
  }

  Future<Barang?> getBarangById(int id) async {
    try {
      return await DBHelper.getBarangById(id);
    } catch (e) {
      throw Exception('Gagal mengambil barang berdasarkan ID: $e');
    }
  }

  Future<List<Barang>> getBarangTerbaru() async {
    try {
      final all = await DBHelper.getAllBarang();
      all.sort((a, b) => (b.tanggalDibuat ?? DateTime(0)).compareTo(a.tanggalDibuat ?? DateTime(0)));
      return all.take(5).toList();
    } catch (e) {
      throw Exception('Gagal mengambil barang terbaru: $e');
    }
  }

  Future<List<Barang>> getBarangPrioritas() async {
    try {
      final all = await DBHelper.getAllBarang();
      all.sort((a, b) {
        int p = (b.isPriority ? 1 : 0) - (a.isPriority ? 1 : 0);
        if (p != 0) return p;
        return b.jumlah.compareTo(a.jumlah);
      });
      return all;
    } catch (e) {
      throw Exception('Gagal mengambil barang prioritas: $e');
    }
  }
  Future<List<Barang>> searchBarangByName(String keyword) async {
  try {
    final all = await DBHelper.getAllBarang();
    return all
        .where((barang) => barang.nama.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  } catch (e) {
    throw Exception('Gagal melakukan pencarian barang: $e');
  }
}

  Future<int> countBarang() async {
    try {
      final all = await DBHelper.getAllBarang();
      return all.length;
    } catch (e) {
      throw Exception('Gagal menghitung total barang: $e');
    }
  }

}
