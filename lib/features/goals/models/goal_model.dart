class Goal {
  String title;
  DateTime deadline;
  List<Subtask> subtasks;

  Goal({
    required this.title,
    required this.deadline,
    List<Subtask>? subtasks,
  }) : subtasks = subtasks ?? [];

  double get progress {
    if (subtasks.isEmpty) return 0;
    final done = subtasks.where((s) => s.done).length;
    return (done / subtasks.length) * 100;
  }

  bool get isCompleted => progress >= 100;
}

class Subtask {
  String title;
  bool done;

  Subtask({required this.title, this.done = false});
}
