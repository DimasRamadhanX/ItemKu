import 'package:flutter/material.dart';
import '../../models/barang_model.dart';

class BarangCard extends StatelessWidget {
  final Barang barang;
  final VoidCallback onTap;

  const BarangCard({super.key, required this.barang, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.primaryContainer : Colors.blue.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(2, 4),
            )
          ],
        ),
        child: Row(
          children: [
            // Text bagian kiri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    barang.nama,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    barang.alamat,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Gambar di kanan
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: barang.imagePath != null
                  ? Image.asset(
                      barang.imagePath!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.image, size: 72, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
