import 'package:flutter/material.dart';
import '../components/bottomnav.dart';
import '../components/customappbar.dart';

class ListBarangScreen extends StatefulWidget {
  const ListBarangScreen({super.key});

  @override
  State<ListBarangScreen> createState() => _ListBarangScreenState();
}

class _ListBarangScreenState extends State<ListBarangScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      appBar: const CustomAppBar(title: 'Daftar Barang'),
      //Menggunakan warna background dari tema
      body: const Center(child: Text('Ini halaman daftar barang')),
      //Jangan hapus rek y urrentIndex 1 agar tab Daftar Barang aktif
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}