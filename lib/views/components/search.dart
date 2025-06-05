import 'package:flutter/material.dart';
import '../../models/barang_model.dart';
import '../../services/barang_service.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(List<Barang>) onSearchResult;

  const SearchBarWidget({super.key, required this.onSearchResult});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final BarangService _barangService = BarangService();

  void _onSearch(String keyword) async {
    if (keyword.isEmpty) {
      final all = await _barangService.getAllBarang();
      widget.onSearchResult(all);
    } else {
      final result = await _barangService.searchBarangByName(keyword);
      widget.onSearchResult(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Cari barang...',
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: _onSearch,
      ),
    );
  }
}
