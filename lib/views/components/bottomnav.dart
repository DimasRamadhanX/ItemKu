import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/list-barang');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BottomNavigationBar(
      backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ?? theme.colorScheme.surface,
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, color: isDark ? Colors.lightBlue[200] : Colors.blue),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, color: isDark ? Colors.lightBlue[200] : Colors.blue),
          label: 'Daftar Barang',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: isDark ? Colors.lightBlue[200] : Colors.blue),
          label: 'Pengaturan',
        ),
      ],
      selectedItemColor: isDark ? Colors.lightBlue[200] : Colors.blue,
      unselectedItemColor: isDark ? Colors.grey[400] : Colors.black54,
      showUnselectedLabels: true,
    );
  }
}
