import 'dart:convert';

class TaskModel {
  final String id;
  final String uid;
  final String title;
  final String description;
  final String priority;
  final String category;
  final bool isCompleted;
  final DateTime dueAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;
  TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    required this.isCompleted,
    required this.dueAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  TaskModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    String? priority,
    String? category,
    bool? isCompleted,
    DateTime? dueAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      dueAt: dueAt ?? this.dueAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'priority': priority,
      'category': category,
      'isCompleted': isCompleted ? 1 : 0,
      'dueAt': dueAt.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isSynced': isSynced,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? '',
      category: map['category'] ?? '',
      dueAt: map['dueAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(
              map['dueAt'],
            )
          : DateTime.parse(
              map['dueAt'],
            ),
      createdAt: map['createdAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(
              map['createdAt'],
            )
          : DateTime.parse(
              map['createdAt'],
            ),
      updatedAt: map['updatedAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(
              map['updatedAt'],
            )
          : DateTime.parse(
              map['updatedAt'],
            ),
      isCompleted: (map['isCompleted'] ?? 0) == 1,
      isSynced: map['isSynced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, uid: $uid, title: $title, description: $description, priority: $priority, category: $category, isCompleted: $isCompleted, dueAt: $dueAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.description == description &&
        other.priority == priority &&
        other.category == category &&
        other.isCompleted == isCompleted &&
        other.dueAt == dueAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        priority.hashCode ^
        category.hashCode ^
        isCompleted.hashCode ^
        dueAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isSynced.hashCode;
  }
}
