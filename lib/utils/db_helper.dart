import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/barang_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Getter untuk database yang hanya akan diinisialisasi sekali
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('barang.db');
    return _database!;
  }

  // Inisialisasi database dan path
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Pembuatan tabel
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE barang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        jumlah INTEGER,
        alamat TEXT,
        deskripsi TEXT,
        imagePath TEXT
      )
    ''');
  }

  // -------------------------------
  // CRUD FUNCTIONS
  // -------------------------------

  Future<int> insertBarang(Barang barang) async {
    final db = await instance.database;
    return await db.insert('barang', barang.toMap());
  }

  Future<List<Barang>> getAllBarang() async {
    final db = await instance.database;
    final result = await db.query('barang', orderBy: 'id DESC');
    return result.map((json) => Barang.fromMap(json)).toList();
  }

  Future<Barang?> getBarangById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'barang',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Barang.fromMap(result.first) : null;
  }

  Future<int> updateBarang(Barang barang) async {
    final db = await instance.database;
    return await db.update(
      'barang',
      barang.toMap(),
      where: 'id = ?',
      whereArgs: [barang.id],
    );
  }

  Future<int> deleteBarang(int id) async {
    final db = await instance.database;
    return await db.delete(
      'barang',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Tutup database (opsional dipanggil saat app ditutup)
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
