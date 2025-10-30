import 'package:flutter/material.dart';

class GoalsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const GoalsSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Поиск по названию...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            controller.clear();
            onChanged();
          },
        )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (_) => onChanged(),
    );
  }
}
