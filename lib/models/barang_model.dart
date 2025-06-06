class Barang {
  int? id;
  String nama;
  int jumlah;
  String alamat;
  String deskripsi;
  String? imagePath;
  DateTime tanggalDibuat; // Hapus nullable
  bool isPriority;

  Barang({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.alamat,
    required this.deskripsi,
    this.imagePath,
    DateTime? tanggalDibuat,
    this.isPriority = false,
  }) : tanggalDibuat = tanggalDibuat ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama.trim(),
      'jumlah': jumlah,
      'alamat': alamat.trim(),
      'deskripsi': deskripsi.trim(),
      'imagePath': imagePath,
      'tanggalDibuat': tanggalDibuat.toIso8601String(),
      'isPriority': isPriority ? 1 : 0,
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    // Penanganan tanggal yang lebih robust
    DateTime parsedTanggal;
    try {
      if (map['tanggalDibuat'] != null && map['tanggalDibuat'].toString().isNotEmpty) {
        parsedTanggal = DateTime.parse(map['tanggalDibuat']);
      } else {
        parsedTanggal = DateTime.now();
      }
    } catch (e) {
      print('Error parsing date: $e');
      parsedTanggal = DateTime.now();
    }

    return Barang(
      id: map['id'],
      nama: map['nama']?.toString() ?? '',
      jumlah: map['jumlah'] ?? 0,
      alamat: map['alamat']?.toString() ?? '',
      deskripsi: map['deskripsi']?.toString() ?? '',
      imagePath: map['imagePath'],
      tanggalDibuat: parsedTanggal,
      isPriority: (map['isPriority'] ?? 0) == 1,
    );
  }

  // Method untuk validasi data
  bool isValid() {
    return nama.trim().isNotEmpty && 
           alamat.trim().isNotEmpty && 
           jumlah > 0;
  }
}