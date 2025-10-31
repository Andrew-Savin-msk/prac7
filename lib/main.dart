import 'package:flutter/material.dart';
import 'features/goals/services/goal_service.dart';
import 'features/goals/app_router.dart';

void main() {
  final goalService = GoalService();
  runApp(MyApp(goalService: goalService));
}

class MyApp extends StatelessWidget {
  final GoalService goalService;
  const MyApp({super.key, required this.goalService});

  @override
  Widget build(BuildContext context) {
    final router = buildRouter(goalService);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Goals',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      routerConfig: router,
    );
  }
}
