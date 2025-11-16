import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:campaign_manager/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:campaign_manager/features/dashboard/domain/repositories/dashboard_repository.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class RefreshDashboard extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardMetrics metrics;
  final List<RecentActivity> recentActivities;

  const DashboardLoaded({
    required this.metrics,
    required this.recentActivities,
  });

  @override
  List<Object?> get props => [metrics, recentActivities];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc(this._repository) : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final metrics = await _repository.getDashboardMetrics();
      final activities = await _repository.getRecentActivities();
      emit(DashboardLoaded(metrics: metrics, recentActivities: activities));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final metrics = await _repository.getDashboardMetrics();
      final activities = await _repository.getRecentActivities();
      emit(DashboardLoaded(metrics: metrics, recentActivities: activities));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
