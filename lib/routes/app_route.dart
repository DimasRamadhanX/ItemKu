import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:myitems/views/screens/tes.dart';

import '../views/screens/dashboard.dart';
import '../views/screens/list.dart';
import '../views/screens/settings.dart';
import '../views/screens/add.dart';
import '../views/screens/splash.dart';
import '../views/screens/detail.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) => const MaterialPage(
          child: SplashScreen(),
          name: 'splash',
        ),
      ),
      GoRoute(
        path: '/tes',
        name: 'tes',
        pageBuilder: (context, state) => const MaterialPage(
          child: TesScreen(),
          name: 'tes',
        ),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) => const MaterialPage(
          child: DashboardScreen(),
          name: 'dashboard',
        ),
      ),
      GoRoute(
        path: '/list-barang',
        name: 'list-barang',
        pageBuilder: (context, state) => const MaterialPage(
          child: ListBarangScreen(),
          name: 'list-barang',
        ),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => const MaterialPage(
          child: SettingsScreen(),
          name: 'settings',
        ),
      ),
      GoRoute(
        path: '/barang/tambah',
        name: 'tambah-barang',
        pageBuilder: (context, state) => const MaterialPage(
          child: AddScreen(),
          name: 'tambah-barang',
        ),
      ),
      GoRoute(
        path: '/barang/:id',
        name: 'detail-barang',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return MaterialPage(
            child: DetailScreen(barangId: id), // Perbaikan: gunakan barangId
            name: 'detail-barang',
          );
        },
      ),
    ],
  );
}