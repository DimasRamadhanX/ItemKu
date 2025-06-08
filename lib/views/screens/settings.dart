import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/bottomnav.dart';
import '../components/customappbar.dart';
import 'ketentuan.dart';
import 'kebijakan.dart';
import 'pusat.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showKetentuan = false;
  bool showKebijakan = false;
  bool showBantuan = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Pengaturan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildButton(
              context,
              title: 'Ketentuan Layanan',
              onPressed: () {
                setState(() {
                  showKetentuan = !showKetentuan;
                });
              },
            ),
            const SizedBox(height: 12),
            if (showKetentuan) ...[
              const KetentuanLayanan(),
              const SizedBox(height: 24),
            ],
            _buildButton(
              context,
              title: 'Kebijakan Privasi',
              onPressed: () {
                setState(() {
                  showKebijakan = !showKebijakan;
                });
              },
            ),
            const SizedBox(height: 12),
            if (showKebijakan) ...[
              const KebijakanPrivasi(),
              const SizedBox(height: 24),
            ],
            _buildButton(
              context,
              title: 'Pusat Bantuan',
              onPressed: () {
                setState(() {
                  showBantuan = !showBantuan;
                });
              },
            ),
            const SizedBox(height: 12),
            if (showBantuan) ...[
              const PusatBantuan(),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String title, required VoidCallback onPressed}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
