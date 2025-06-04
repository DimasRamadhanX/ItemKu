
import 'package:flutter/material.dart';
import '../components/bottomnav.dart';
import '../components/customappbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor, 
      appBar: const CustomAppBar(title: 'Settings'),
      body: Center(child: Text('Settings')),
      //jangan dihapus bottom navbar
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}