import 'package:flutter/material.dart';

class PusatBantuan extends StatelessWidget {
  const PusatBantuan({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '''
Pusat Bantuan:

Jika Anda mengalami kesulitan dalam menggunakan FindThings, berikut beberapa hal yang bisa dicoba:
1. Pastikan aplikasi telah mendapatkan izin kamera dan penyimpanan.
2. Gunakan fitur pencarian untuk menemukan barang berdasarkan nama atau deskripsi.
3. Perbarui aplikasi secara berkala untuk mendapatkan fitur terbaru.
4. Hubungi kami melalui email support@findthings.app untuk bantuan lebih lanjut.

Kami siap membantu Anda!
''',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
