// FilterDropdown.dart
import 'package:flutter/material.dart';

enum SortOrder { az, za }

class FilterDropdown extends StatelessWidget {
  final SortOrder currentOrder;
  final Function(SortOrder) onChanged;

  const FilterDropdown({
    super.key,
    required this.currentOrder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SortOrder>(
      value: currentOrder,
      items: const [
        DropdownMenuItem(
          value: SortOrder.az,
          child: Text('A-Z'),
        ),
        DropdownMenuItem(
          value: SortOrder.za,
          child: Text('Z-A'),
        ),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}