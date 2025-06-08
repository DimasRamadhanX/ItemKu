import 'package:flutter/material.dart';

class KebijakanPrivasi extends StatelessWidget {
  const KebijakanPrivasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '''
Kebijakan Privasi:
1. FindThings tidak mengumpulkan data pribadi Anda.
2. Semua informasi tentang barang disimpan secara lokal di perangkat Anda.
3. Kami tidak memiliki akses ke lokasi, kamera, atau file Anda tanpa izin eksplisit.
4. Pengguna dapat menghapus data kapan saja dari dalam aplikasi.
5. Kami tidak menggunakan data Anda untuk tujuan komersial atau periklanan.

Privasi Anda adalah prioritas kami.
''',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
