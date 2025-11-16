import 'package:campaign_manager/features/tasks/data/models/task_model.dart';
import 'package:campaign_manager/shared/services/database_service.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> getPendingTasks();
  Future<List<TaskModel>> getCompletedTasks();
  Future<List<TaskModel>> getTasksByPriority(String priority);
  Future<List<TaskModel>> getTasksByCampaignId(String campaignId);
  Future<TaskModel?> getTaskById(String id);
  Future<void> insertTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> toggleTaskCompletion(String id, bool isCompleted);
  Future<int> getPendingTasksCount();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseService _databaseService;

  TaskLocalDataSourceImpl(this._databaseService);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'tasks',
      orderBy: 'is_completed ASC, due_date ASC, priority DESC',
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<List<TaskModel>> getPendingTasks() async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'tasks',
      where: 'is_completed = ?',
      whereArgs: [0],
      orderBy: 'due_date ASC, priority DESC',
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<List<TaskModel>> getCompletedTasks() async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'tasks',
      where: 'is_completed = ?',
      whereArgs: [1],
      orderBy: 'completed_at DESC',
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<List<TaskModel>> getTasksByPriority(String priority) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'tasks',
      where: 'priority = ? AND is_completed = ?',
      whereArgs: [priority, 0],
      orderBy: 'due_date ASC',
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<List<TaskModel>> getTasksByCampaignId(String campaignId) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'tasks',
      where: 'campaign_id = ?',
      whereArgs: [campaignId],
      orderBy: 'is_completed ASC, due_date ASC',
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return TaskModel.fromMap(maps.first);
  }

  @override
  Future<void> insertTask(TaskModel task) async {
    final db = await _databaseService.database;
    await db.insert('tasks', task.toMap());
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final db = await _databaseService.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    final db = await _databaseService.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'tasks',
      {
        'is_completed': isCompleted ? 1 : 0,
        'completed_at': isCompleted ? now : null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> getPendingTasksCount() async {
    final db = await _databaseService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE is_completed = ?',
      [0],
    );
    return result.first['count'] as int;
  }
}
