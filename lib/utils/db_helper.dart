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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            jumlah INTEGER NOT NULL,
            alamat TEXT NOT NULL,
            deskripsi TEXT NOT NULL DEFAULT '',
            imagePath TEXT,
            tanggalDibuat TEXT NOT NULL,
            isPriority INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  static Future<int> insertBarang(Barang barang) async {
    try {
      final db = await database;
      
      // Validasi data sebelum insert
      final data = barang.toMap();
      
      // Pastikan tanggalDibuat tidak null
      if (data['tanggalDibuat'] == null || data['tanggalDibuat'] == '') {
        data['tanggalDibuat'] = DateTime.now().toIso8601String();
      }
      
      // Pastikan deskripsi tidak null
      data['deskripsi'] = data['deskripsi'] ?? '';
      
      return await db.insert(_tableName, data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Barang>> getAllBarang() async {
    try {
      final db = await database;
      final result = await db.query(_tableName, orderBy: 'id DESC');
      return result.map((map) => Barang.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<int> updateBarang(Barang barang) async {
    try {
      final db = await database;
      return await db.update(
        _tableName,
        barang.toMap(),
        where: 'id = ?',
        whereArgs: [barang.id],
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<Barang?> getBarangById(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Barang.fromMap(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<int> deleteBarang(int id) async {
    try {
      final db = await database;
      return await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteDatabaseFile() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'barang.db');
      await deleteDatabase(path);
      _database = null; // ✅ Fixed: was *database = null
    } catch (e) {
      rethrow;
    }
  }
}