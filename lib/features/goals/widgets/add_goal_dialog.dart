import 'package:flutter/material.dart';
import '../models/goal_model.dart';

class AddGoalDialog extends StatefulWidget {
  const AddGoalDialog({super.key});

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _deadline;

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новая цель'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Название цели'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                _deadline == null
                    ? 'Дата не выбрана'
                    : 'Срок: ${_deadline!.day}.${_deadline!.month}.${_deadline!.year}',
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isEmpty || _deadline == null) return;
            final goal = Goal(title: _controller.text, deadline: _deadline!);
            Navigator.pop(context, goal);
          },
          child: const Text('Создать'),
        ),
      ],
    );
  }
}
