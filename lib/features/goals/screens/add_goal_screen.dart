import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_router.dart';
import '../models/goal_model.dart';
import '../services/goal_service.dart';
import 'goals_list_screen.dart';

class AddGoalScreen extends StatefulWidget {
  final GoalService goalService;
  const AddGoalScreen({super.key, required this.goalService});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _deadline;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
      initialDate: _deadline ?? now,
      helpText: 'Выберите срок выполнения',
      cancelText: 'Отмена',
      confirmText: 'Готово',
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите срок выполнения')),
      );
      return;
    }

    final goal = Goal(
      title: _titleController.text.trim(),
      deadline: _deadline!,
    );

    widget.goalService.addGoal(goal);

    context.go(Routes.goalsList);
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _titleController.text.trim().isNotEmpty && _deadline != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая цель'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Название цели',
                hintText: 'Например: Выучить основы Dart',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Введите название';
                if (v.trim().length < 3) return 'Минимум 3 символа';
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Срок выполнения'),
              subtitle: Text(
                _deadline == null
                    ? 'Не выбрано'
                    : '${_deadline!.day.toString().padLeft(2, '0')}.'
                    '${_deadline!.month.toString().padLeft(2, '0')}.'
                    '${_deadline!.year}',
              ),
              trailing: FilledButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.event),
                label: const Text('Выбрать дату'),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: canSave ? _save : null,
              icon: const Icon(Icons.check),
              label: const Text('Создать цель'),
            ),
          ],
        ),
      ),
    );
  }
}
