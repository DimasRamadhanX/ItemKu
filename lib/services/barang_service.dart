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
    return await DBHelper.getBarangById(id);
  }

  Future<List<Barang>> getBarangTerbaru() async {
    final all = await DBHelper.getAllBarang();
    all.sort((a, b) => (b.tanggalDibuat ?? DateTime(0)).compareTo(a.tanggalDibuat ?? DateTime(0)));
    return all.take(5).toList();
  }

  Future<List<Barang>> getBarangPrioritas() async {
    final all = await DBHelper.getAllBarang();
    all.sort((a, b) {
      // Ubah boolean ke int, lalu bandingkan supaya prioritas (1) di atas (urutan menurun)
      int p = (b.isPriority ? 1 : 0) - (a.isPriority ? 1 : 0);
      if (p != 0) return p; // Kalau beda prioritas, pakai hasil ini
      // Kalau prioritas sama, urut berdasarkan jumlah menurun
      return b.jumlah.compareTo(a.jumlah);
    });
    return all;  // ambil semua tanpa batasan jumlah
  }

}
