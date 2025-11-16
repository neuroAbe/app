import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:campaign_manager/features/tasks/domain/entities/task_entity.dart';
import 'package:campaign_manager/features/tasks/domain/repositories/task_repository.dart';

// Events
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class LoadPendingTasks extends TaskEvent {}

class LoadCompletedTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final TaskEntity task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final TaskEntity task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskCompletion extends TaskEvent {
  final String taskId;
  final bool isCompleted;

  const ToggleTaskCompletion({
    required this.taskId,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [taskId, isCompleted];
}

// States
abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final bool showCompleted;

  const TasksLoaded({
    required this.tasks,
    this.showCompleted = false,
  });

  @override
  List<Object?> get props => [tasks, showCompleted];
}

class TaskOperationSuccess extends TaskState {
  final String message;

  const TaskOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;

  TaskBloc(this._repository) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<LoadPendingTasks>(_onLoadPendingTasks);
    on<LoadCompletedTasks>(_onLoadCompletedTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await _repository.getAllTasks();
      emit(TasksLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onLoadPendingTasks(
    LoadPendingTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await _repository.getPendingTasks();
      emit(TasksLoaded(tasks: tasks, showCompleted: false));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onLoadCompletedTasks(
    LoadCompletedTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await _repository.getCompletedTasks();
      emit(TasksLoaded(tasks: tasks, showCompleted: true));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(
    AddTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _repository.addTask(event.task);
      emit(const TaskOperationSuccess('Task added successfully'));
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _repository.updateTask(event.task);
      emit(const TaskOperationSuccess('Task updated successfully'));
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _repository.deleteTask(event.taskId);
      emit(const TaskOperationSuccess('Task deleted successfully'));
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _repository.toggleTaskCompletion(event.taskId, event.isCompleted);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
