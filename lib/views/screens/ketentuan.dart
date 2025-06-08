import 'package:flutter/material.dart';

class KetentuanLayanan extends StatelessWidget {
  const KetentuanLayanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '''
Ketentuan Layanan:

1. Aplikasi ini digunakan untuk mencatat dan menyimpan informasi lokasi barang pribadi.
2. Pengguna bertanggung jawab atas data yang diunggah ke aplikasi.
3. Kami tidak menyimpan data Anda secara eksternal, semua data disimpan di perangkat Anda.
4. Fitur pencarian hanya berfungsi berdasarkan data yang telah dimasukkan sebelumnya.
5. Aplikasi ini tidak bertanggung jawab atas kehilangan barang yang tidak tercatat.

Terima kasih telah menggunakan FindThings!
''',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
