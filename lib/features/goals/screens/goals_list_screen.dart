import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import '../services/goal_service.dart';
import '../widgets/add_goal_dialog.dart';
import '../widgets/goals_stats_card.dart';
import '../widgets/goals_search_bar.dart';
import '../widgets/goals_list_view.dart';
import 'add_goal_screen.dart';
import 'completed_goals_screen.dart';
import 'goal_detail_screen.dart';
import 'profile_screen.dart';


class GoalsListScreen extends StatefulWidget {
  const GoalsListScreen({super.key});

  @override
  State<GoalsListScreen> createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  final GoalService _goalService = GoalService();
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'none';

  void _addGoal() async {
    final goal = await Navigator.push<Goal>(
             context,
            MaterialPageRoute(builder: (_) => const AddGoalScreen()),
            );
        if (goal != null) setState(() => _goalService.addGoal(goal));
  }

  void _deleteGoal(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить цель?'),
        content: const Text('Вы уверены, что хотите удалить эту цель?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить все цели?'),
        content: const Text('Это действие удалит все цели без возможности восстановления.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _goalService.goals.clear());
              Navigator.pop(context);
            },
            child: const Text('Очистить всё'),
          ),
        ],
      ),
    );
  }

  void _sortGoals(String type) {
    setState(() {
      _sortBy = type;
      if (type == 'date') {
        _goalService.goals.sort((a, b) => a.deadline.compareTo(b.deadline));
      } else if (type == 'progress') {
        _goalService.goals.sort((a, b) => b.progress.compareTo(a.progress));
      } else if (type == 'name') {
        _goalService.goals.sort((a, b) => a.title.compareTo(b.title));
      }
    });
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompletedGoalsScreen(goalService: _goalService),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Профиль',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: _sortGoals,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'none', child: Text('Без сортировки')),
              PopupMenuItem(value: 'name', child: Text('По названию')),
              PopupMenuItem(value: 'date', child: Text('По дате')),
              PopupMenuItem(value: 'progress', child: Text('По прогрессу')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Очистить всё',
            onPressed: _goalService.goals.isEmpty ? null : _clearAll,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GoalsStatsCard(goalService: _goalService),
            GoalsSearchBar(controller: _searchController, onChanged: () => setState(() {})),
            const SizedBox(height: 10),
            Expanded(
              child: GoalsListView(
                goals: goals,
                onDelete: _deleteGoal,
                onTap: (goal) async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoalDetailScreen(goal: goal)),
                  );
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
}
