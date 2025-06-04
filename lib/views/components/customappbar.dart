import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Ambil nama route aktif
    final currentRouteName = ModalRoute.of(context)?.settings.name;
    final isOnDashboard = currentRouteName == 'dashboard';

    return AppBar(
      automaticallyImplyLeading: false,
      leading: isOnDashboard
          ? null
          : IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark ? Colors.lightBlue[200] : Colors.blue,
              ),
              onPressed: () {
                context.go('/dashboard');
              },
            ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.lightBlue[200] : Colors.blue,
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
