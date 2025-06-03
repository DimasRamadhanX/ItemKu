class Barang {
  int? id;
  String nama;
  int jumlah;
  String alamat;
  String deskripsi;
  String? imagePath; // Path gambar lokal

  Barang({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.alamat,
    required this.deskripsi,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'jumlah': jumlah,
      'alamat': alamat,
      'deskripsi': deskripsi,
      'imagePath': imagePath,
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
    );
  }
}