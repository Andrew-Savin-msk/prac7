import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import 'goal_card.dart';

class GoalsListView extends StatelessWidget {
  final List<Goal> goals;
  final Function(int) onDelete;
  final Function(Goal) onTap;

  const GoalsListView({
    super.key,
    required this.goals,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return const Center(child: Text('Нет подходящих целей'));
    }

    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return GoalCard(
          goal: goal,
          onDelete: () => onDelete(index),
          onTap: () => onTap(goal),
        );
      },
    );
  }
}
