
import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import '../services/goal_service.dart';
import '../widgets/goal_card.dart';
import 'goal_detail_screen.dart';

class CompletedGoalsScreen extends StatefulWidget {
  final GoalService goalService;

  const CompletedGoalsScreen({super.key, required this.goalService});

  @override
  State<CompletedGoalsScreen> createState() => _CompletedGoalsScreenState();
}

class _CompletedGoalsScreenState extends State<CompletedGoalsScreen> {
  List<MapEntry<int, Goal>> _completedEntries() {
    // keep original indices to delete correctly from the backing list
    return widget.goalService.goals.asMap().entries
        .where((e) => e.value.isCompleted)
        .toList();
  }

  void _deleteAllCompleted() async {
    final count = _completedEntries().length;
    if (count == 0) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить выполненные цели?'),
        content: Text('Будут удалены $count выполненных целей. Действие необратимо.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (ok == true) {
      setState(() {
        widget.goalService.goals.removeWhere((g) => g.isCompleted);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Удалено целей: $count')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = _completedEntries();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выполненные цели'),
        actions: [
          IconButton(
            tooltip: 'Удалить все',
            onPressed: entries.isEmpty ? null : _deleteAllCompleted,
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: entries.isEmpty
          ? const _EmptyCompletedState()
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final originalIndex = entries[i].key;
          final goal = entries[i].value;

          return GoalCard(
            goal: goal,
            onDelete: () {
              setState(() {
                widget.goalService.deleteGoal(originalIndex);
              });
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GoalDetailScreen(goal: goal),
                ),
              ).then((_) => setState(() {}));
            },
          );
        },
      ),
    );
  }
}

class _EmptyCompletedState extends StatelessWidget {
  const _EmptyCompletedState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 64),
            const SizedBox(height: 12),
            const Text(
              'Нет выполненных целей',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Отметьте все подзадачи внутри цели, и она попадёт сюда автоматически.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
