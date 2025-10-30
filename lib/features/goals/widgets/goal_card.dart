import 'package:flutter/material.dart';
import '../models/goal_model.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onDelete,
    required this.onTap,
  });

  Color _getColor(double progress) {
    if (progress >= 100) return Colors.green.shade200;
    if (progress >= 50) return Colors.yellow.shade200;
    return Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getColor(goal.progress),
      child: ListTile(
        title: Text(goal.title),
        subtitle: Text(
          'Прогресс: ${goal.progress.toStringAsFixed(0)}% • '
              'Срок: ${goal.deadline.day}.${goal.deadline.month}.${goal.deadline.year}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
