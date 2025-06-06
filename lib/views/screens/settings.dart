import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/bottomnav.dart';
import '../components/customappbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Pengaturan'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildButton(
              context,
              title: 'Ketentuan Layanan',
              onPressed: () {
                // context.goNamed('ketentuan');
              },
            ),
            const SizedBox(height: 12),
            _buildButton(
              context,
              title: 'Kebijakan Privasi',
              onPressed: () {
                // context.goNamed('kebijakan');
              },
            ),
            const SizedBox(height: 12),
            _buildButton(
              context,
              title: 'Pusat Bantuan',
              onPressed: () {
                // context.goNamed('bantuan');
              },
            ),
          ],
        ),
      ),
      // jangan dihapus bottom navbar
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
