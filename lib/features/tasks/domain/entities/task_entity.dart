import 'package:equatable/equatable.dart';

enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? campaignId;
  final TaskPriority priority;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    this.campaignId,
    required this.priority,
    this.dueDate,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        campaignId,
        priority,
        dueDate,
        isCompleted,
        createdAt,
        completedAt,
      ];

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? campaignId,
    TaskPriority? priority,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      campaignId: campaignId ?? this.campaignId,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }
}
