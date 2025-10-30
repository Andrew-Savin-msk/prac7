import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/goal_model.dart';
import 'services/goal_service.dart';
import 'screens/goals_list_screen.dart';
import 'screens/add_goal_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/completed_goals_screen.dart';
import 'screens/goal_detail_screen.dart';

final class Routes {
  static const goalsList = '/';
  static const addGoal = '/add-goal';
  static const profile = '/profile';
  static const completed = '/completed';
  static const goalDetail = '/goal-detail'; // будем передавать Goal через extra
}

GoRouter buildRouter(GoalService goalService) {
  return GoRouter(
    initialLocation: Routes.goalsList,
    routes: [
      GoRoute(
        path: Routes.goalsList,
        name: 'goalsList',
        builder: (context, state) => GoalsListScreen(goalService: goalService),
      ),
      GoRoute(
        path: Routes.addGoal,
        name: 'addGoal',
        builder: (context, state) => AddGoalScreen(goalService: goalService),
      ),
      GoRoute(
        path: Routes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.completed,
        name: 'completed',
        builder: (context, state) => CompletedGoalsScreen(goalService: goalService),
      ),
      GoRoute(
        path: Routes.goalDetail,
        name: 'goalDetail',
        builder: (context, state) {
          final goal = state.extra as Goal;
          return GoalDetailScreen(goal: goal);
        },
      ),
    ],
  );
}

