import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import '../widgets/progress_text.dart';

class GoalDetailScreen extends StatefulWidget {
  final Goal goal;

  const GoalDetailScreen({super.key, required this.goal});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  final TextEditingController _subtaskController = TextEditingController();

  void _addSubtask() {
    final text = _subtaskController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      widget.goal.subtasks.add(Subtask(title: text));
      _subtaskController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;
    final subtasks = goal.subtasks;

    return Scaffold(
      appBar: AppBar(title: Text(goal.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProgressText(progress: goal.progress),
            const Divider(),
            TextField(
              controller: _subtaskController,
              decoration: const InputDecoration(labelText: 'Добавить подзадачу'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addSubtask,
              child: const Text('Добавить'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: subtasks.isEmpty
                  ? const Center(child: Text('Подзадач пока нет'))
                  : ListView.builder(
                itemCount: subtasks.length,
                itemBuilder: (context, index) {
                  final sub = subtasks[index];
                  return CheckboxListTile(
                    title: Text(sub.title),
                    value: sub.done,
                    onChanged: (val) {
                      setState(() => sub.done = val ?? false);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
