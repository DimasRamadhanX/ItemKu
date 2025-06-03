class Barang {
  int? id;
  String nama;
  int jumlah;
  String alamat;
  String deskripsi;
  String? imagePath; // Path gambar lokal
  DateTime? tanggalDibuat; // Field tanggal
  bool isPriority; // atribut baru

  Barang({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.alamat,
    required this.deskripsi,
    this.imagePath,
    this.tanggalDibuat,
    this.isPriority = false,  // default false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'jumlah': jumlah,
      'alamat': alamat,
      'deskripsi': deskripsi,
      'imagePath': imagePath,
      'tanggalDibuat': tanggalDibuat?.toIso8601String(),
      'isPriority': isPriority ? 1 : 0,  // simpan sebagai integer 1/0 di db
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id'],
      nama: map['nama'],
      jumlah: map['jumlah'],
      alamat: map['alamat'],
      deskripsi: map['deskripsi'],
      imagePath: map['imagePath'],
      tanggalDibuat: map['tanggalDibuat'] != null
          ? DateTime.tryParse(map['tanggalDibuat'])
          : null,
      isPriority: (map['isPriority'] ?? 0) == 1,  // baca dari int ke bool
    );
  }
}
