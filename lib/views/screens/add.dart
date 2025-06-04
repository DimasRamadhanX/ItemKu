import 'package:flutter/material.dart';
import '../components/bottomnav.dart';
import '../components/customappbar.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Tambah Barang'),
      body: Center(child: Text('add item')),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}

