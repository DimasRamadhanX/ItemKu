import 'package:flutter/material.dart';
import '../routes/app_route.dart'; // Import router dari file terpisah

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system, // Gunakan mode tema sistem

      debugShowCheckedModeBanner: false,
      routerConfig: AppRoute.router, // Gunakan router dari app_route.dart
    );
  }
}
