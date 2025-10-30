import '../models/goal_model.dart';

class GoalService {
  final List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  void addGoal(Goal goal) => _goals.add(goal);

  void deleteGoal(int index) => _goals.removeAt(index);
}
