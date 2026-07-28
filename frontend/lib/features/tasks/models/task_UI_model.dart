enum TaskPriority {
  chill('Chill'),
  focused('Focused'),
  urgent('Urgent');

  final String label;

  const TaskPriority(this.label);
}

class TaskUIModel {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime scheduledAt;
  final String? category;
  final bool isCompleted;
  final DateTime? completedAt;

  const TaskUIModel({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.scheduledAt,
    this.category,
    this.isCompleted = false,
    this.completedAt,
  });

  TaskUIModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    DateTime? scheduledAt,
    String? category,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return TaskUIModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String get formattedStartTime => formatTime(scheduledAt);

  String get time => formattedStartTime;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskUIModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          priority == other.priority;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ priority.hashCode;
}
