import 'package:campaign_manager/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getAllTasks();
  Future<List<TaskEntity>> getPendingTasks();
  Future<List<TaskEntity>> getCompletedTasks();
  Future<List<TaskEntity>> getTasksByPriority(TaskPriority priority);
  Future<List<TaskEntity>> getTasksByCampaignId(String campaignId);
  Future<TaskEntity?> getTaskById(String id);
  Future<void> addTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String id);
  Future<void> toggleTaskCompletion(String id, bool isCompleted);
  Future<int> getPendingTasksCount();
}
