import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/barang_model.dart';

class DBHelper {
  static Database? _database;
  static const String _tableName = 'barang';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'barang.db');

    return await openDatabase(
      path,
      version: 1, // versi 1 karena tanpa upgrade lagi
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            jumlah INTEGER NOT NULL,
            alamat TEXT NOT NULL,
            deskripsi TEXT NOT NULL,
            imagePath TEXT,
            tanggalDibuat TEXT,
            isPriority INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  static Future<int> insertBarang(Barang barang) async {
    final db = await database;
    return await db.insert(_tableName, barang.toMap());
  }

  static Future<List<Barang>> getAllBarang() async {
    final db = await database;
    final result = await db.query(_tableName, orderBy: 'id DESC');
    return result.map((map) => Barang.fromMap(map)).toList();
  }

  static Future<int> updateBarang(Barang barang) async {
    final db = await database;
    return await db.update(
      _tableName,
      barang.toMap(),
      where: 'id = ?',
      whereArgs: [barang.id],
    );
  }

  static Future<int> deleteBarang(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'barang.db');
    await deleteDatabase(path);
    _database = null;
  }
}
