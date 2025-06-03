import 'package:go_router/go_router.dart';
import '../views/screens/dashboard.dart';
import '../views/screens/list.dart';
import '../views/screens/settings.dart';
import '../views/screens/add.dart';
import '../views/screens/splash.dart';
// import 'views/screens/detail.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // Mulai dari splash screen
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/list-barang',
        name: 'list-barang',
        builder: (context, state) => const ListBarangScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/barang/tambah',
        name: 'tambah-barang',
        builder: (context, state) => const AddScreen(),
      ),
      // GoRoute(
      //   path: '/barang/:id',
      //   name: 'detail-barang',
      //   builder: (context, state) {
      //     final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
      //     return DetailScreen(id: id);
      //   },
      // ),
    ],
  );
}
