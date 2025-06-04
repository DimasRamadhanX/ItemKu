import 'package:flutter/material.dart';
import '../components/bottomnav.dart';
import '../components/customappbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Dashboard'),
      body: const Center(child: Text('Selamat datang di Dashboard!')),
      //jangan dihapus bottom navbar
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
