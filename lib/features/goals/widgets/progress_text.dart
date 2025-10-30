import 'package:flutter/material.dart';

class ProgressText extends StatelessWidget {
  final double progress;

  const ProgressText({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Прогресс: ${progress.toStringAsFixed(0)}%',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
