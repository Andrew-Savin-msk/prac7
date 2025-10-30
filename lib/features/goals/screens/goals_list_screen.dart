import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_router.dart';
import '../models/goal_model.dart';
import '../services/goal_service.dart';
import '../widgets/goals_stats_card.dart';
import '../widgets/goals_search_bar.dart';
import '../widgets/goals_list_view.dart';
import 'add_goal_screen.dart';
import 'completed_goals_screen.dart';
import 'goal_detail_screen.dart';
import 'profile_screen.dart';

class GoalsListScreen extends StatefulWidget {
  final GoalService? goalService;
  const GoalsListScreen({super.key, this.goalService});

  @override
  State<GoalsListScreen> createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  late final GoalService _goalService = widget.goalService ?? GoalService();
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'none';

  void _deleteGoal(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить цель?'),
        content: const Text('Вы уверены, что хотите удалить эту цель?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _goalService.deleteGoal(index));
              Navigator.pop(context);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  List<Goal> _filteredGoals() {
    final query = _searchController.text.toLowerCase();
    return _goalService.goals
        .where((g) => g.title.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final goals = _filteredGoals();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Менеджер целей'),
        actions: [
          IconButton(
            tooltip: 'Выполненные',
            icon: const Icon(Icons.done_all),
            onPressed: () {
              context.push(Routes.completed);
            },
          ),
          IconButton(
            tooltip: 'Профиль',
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push(Routes.profile);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GoalsStatsCard(goalService: _goalService),
            GoalsSearchBar(
              controller: _searchController,
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GoalsListView(
                goals: goals,
                onDelete: _deleteGoal,
                onTap: (goal) async {
                  await context.push(Routes.goalDetail, extra: goal);
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addGoal,
        label: const Text('Новая цель'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _addGoal() {
    context.push(Routes.addGoal);
  }
}
