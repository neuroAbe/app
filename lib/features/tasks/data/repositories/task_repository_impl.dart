import 'package:campaign_manager/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:campaign_manager/features/tasks/data/models/task_model.dart';
import 'package:campaign_manager/features/tasks/domain/entities/task_entity.dart';
import 'package:campaign_manager/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;

  TaskRepositoryImpl(this._localDataSource);

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    return await _localDataSource.getAllTasks();
  }

  @override
  Future<List<TaskEntity>> getPendingTasks() async {
    return await _localDataSource.getPendingTasks();
  }

  @override
  Future<List<TaskEntity>> getCompletedTasks() async {
    return await _localDataSource.getCompletedTasks();
  }

  @override
  Future<List<TaskEntity>> getTasksByPriority(TaskPriority priority) async {
    final priorityString = _priorityToString(priority);
    return await _localDataSource.getTasksByPriority(priorityString);
  }

  @override
  Future<List<TaskEntity>> getTasksByCampaignId(String campaignId) async {
    return await _localDataSource.getTasksByCampaignId(campaignId);
  }

  @override
  Future<TaskEntity?> getTaskById(String id) async {
    return await _localDataSource.getTaskById(id);
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _localDataSource.insertTask(model);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _localDataSource.updateTask(model);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _localDataSource.deleteTask(id);
  }

  @override
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    await _localDataSource.toggleTaskCompletion(id, isCompleted);
  }

  @override
  Future<int> getPendingTasksCount() async {
    return await _localDataSource.getPendingTasksCount();
  }

  String _priorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'low';
      case TaskPriority.medium:
        return 'medium';
      case TaskPriority.high:
        return 'high';
      case TaskPriority.urgent:
        return 'urgent';
    }
  }
}
