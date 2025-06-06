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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey.shade300,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortOrder>(
          value: currentOrder,
          icon: Icon(
            Icons.arrow_drop_down,
            color: isDark ? Colors.white : Colors.black,
          ),
          dropdownColor: isDark ? Colors.grey[900] : Colors.white,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          items: const [
            DropdownMenuItem(
              value: SortOrder.az,
              child: Row(
                children: [
                  Icon(Icons.sort_by_alpha, size: 18),
                  SizedBox(width: 4),
                  Text("A-Z"),
                ],
              ),
            ),
            DropdownMenuItem(
              value: SortOrder.za,
              child: Row(
                children: [
                  Icon(Icons.sort_by_alpha, size: 18),
                  SizedBox(width: 4),
                  Text("Z-A"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
