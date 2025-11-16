import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:campaign_manager/core/constants/app_colors.dart';
import 'package:campaign_manager/core/constants/app_dimensions.dart';
import 'package:campaign_manager/core/constants/app_strings.dart';
import 'package:campaign_manager/core/widgets/loading_indicator.dart';
import 'package:campaign_manager/core/widgets/error_view.dart';
import 'package:campaign_manager/core/widgets/empty_state.dart';
import 'package:campaign_manager/core/utils/extensions.dart';
import 'package:campaign_manager/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:campaign_manager/features/tasks/domain/entities/task_entity.dart';
import 'package:uuid/uuid.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.tasks),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'all':
                  context.read<TaskBloc>().add(LoadTasks());
                  break;
                case 'pending':
                  context.read<TaskBloc>().add(LoadPendingTasks());
                  break;
                case 'completed':
                  context.read<TaskBloc>().add(LoadCompletedTasks());
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Tasks'),
              ),
              const PopupMenuItem(
                value: 'pending',
                child: Text('Pending'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Completed'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskOperationSuccess) {
            context.showSnackBar(state.message);
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const LoadingIndicator();
          }

          if (state is TaskError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<TaskBloc>().add(LoadTasks());
              },
            );
          }

          if (state is TasksLoaded) {
            if (state.tasks.isEmpty) {
              return EmptyState(
                icon: Icons.task_outlined,
                title: 'No Tasks Found',
                subtitle: 'Create a task to stay organized',
                action: ElevatedButton.icon(
                  onPressed: () => _showAddTaskDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text(AppStrings.newTask),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(LoadTasks());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return _buildTaskTile(task);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskTile(TaskEntity task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                context.read<TaskBloc>().add(DeleteTask(task.id));
              },
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                context.read<TaskBloc>().add(
                      ToggleTaskCompletion(
                        taskId: task.id,
                        isCompleted: value ?? false,
                      ),
                    );
              },
              activeColor: AppColors.success,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: task.isCompleted
                    ? AppColors.textTertiary
                    : AppColors.textPrimary,
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description != null) ...[
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    task.description!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    _buildPriorityBadge(task.priority),
                    const SizedBox(width: AppDimensions.sm),
                    if (task.dueDate != null) _buildDueDateBadge(task),
                  ],
                ),
              ],
            ),
            isThreeLine: task.description != null,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(TaskPriority priority) {
    Color color;
    String label;

    switch (priority) {
      case TaskPriority.low:
        color = AppColors.textSecondary;
        label = 'Low';
        break;
      case TaskPriority.medium:
        color = AppColors.info;
        label = 'Medium';
        break;
      case TaskPriority.high:
        color = AppColors.warning;
        label = 'High';
        break;
      case TaskPriority.urgent:
        color = AppColors.error;
        label = 'Urgent';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDueDateBadge(TaskEntity task) {
    Color color = AppColors.textSecondary;
    String text = task.dueDate!.formatted;

    if (task.isOverdue) {
      color = AppColors.error;
      text = 'Overdue';
    } else if (task.isDueToday) {
      color = AppColors.warning;
      text = 'Due Today';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.schedule,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title',
                        hintText: 'Enter task title',
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        hintText: 'Enter task description',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    DropdownButtonFormField<TaskPriority>(
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                      ),
                      items: TaskPriority.values.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(priority.name.capitalize),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      final task = TaskEntity(
                        id: const Uuid().v4(),
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim().isEmpty
                            ? null
                            : descriptionController.text.trim(),
                        priority: selectedPriority,
                        isCompleted: false,
                        createdAt: DateTime.now(),
                        dueDate: DateTime.now().add(const Duration(days: 1)),
                      );
                      this.context.read<TaskBloc>().add(AddTask(task));
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
