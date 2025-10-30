import 'package:flutter/material.dart';
import 'features/goals/screens/goals_list_screen.dart';

void main() {
  runApp(const GoalManagerApp());
}

class GoalManagerApp extends StatelessWidget {
  const GoalManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Менеджер целей',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const GoalsListScreen(),
    );
  }
}
