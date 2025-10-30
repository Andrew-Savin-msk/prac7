
import 'package:flutter/material.dart';
import '../models/goal_model.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

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
    final goal = Goal(title: _titleController.text.trim(), deadline: _deadline!);
    Navigator.of(context).pop<Goal>(goal);
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _titleController.text.trim().isNotEmpty && _deadline != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая цель'),
        actions: [
          TextButton(
            onPressed: canSave ? _save : null,
            child: const Text('Создать'),
          ),
        ],
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
                hintText: 'Например: Выучить Dart на базовом уровне',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Введите название' : null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Срок выполнения'),
              subtitle: Text(
                _deadline == null
                    ? 'Не выбран'
                    : '${_deadline!.day}.${_deadline!.month}.${_deadline!.year}',
              ),
              trailing: OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.date_range),
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
