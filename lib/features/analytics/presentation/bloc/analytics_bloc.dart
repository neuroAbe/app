import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:campaign_manager/features/analytics/domain/entities/metric_entity.dart';
import 'package:campaign_manager/features/analytics/domain/repositories/analytics_repository.dart';

// Events
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalytics extends AnalyticsEvent {}

class LoadCampaignAnalytics extends AnalyticsEvent {
  final String campaignId;

  const LoadCampaignAnalytics(this.campaignId);

  @override
  List<Object?> get props => [campaignId];
}

// States
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final List<MetricEntity> recentMetrics;
  final AggregatedMetrics aggregatedMetrics;

  const AnalyticsLoaded({
    required this.recentMetrics,
    required this.aggregatedMetrics,
  });

  @override
  List<Object?> get props => [recentMetrics, aggregatedMetrics];
}

class CampaignAnalyticsLoaded extends AnalyticsState {
  final String campaignId;
  final List<MetricEntity> metrics;

  const CampaignAnalyticsLoaded({
    required this.campaignId,
    required this.metrics,
  });

  @override
  List<Object?> get props => [campaignId, metrics];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsBloc(this._repository) : super(AnalyticsInitial()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<LoadCampaignAnalytics>(_onLoadCampaignAnalytics);
  }

  Future<void> _onLoadAnalytics(
    LoadAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final recentMetrics = await _repository.getAllRecentMetrics(7);
      final aggregatedMetrics = await _repository.getAggregatedMetrics();
      emit(AnalyticsLoaded(
        recentMetrics: recentMetrics,
        aggregatedMetrics: aggregatedMetrics,
      ));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onLoadCampaignAnalytics(
    LoadCampaignAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final metrics = await _repository.getMetricsByCampaignId(event.campaignId);
      emit(CampaignAnalyticsLoaded(
        campaignId: event.campaignId,
        metrics: metrics,
      ));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }
}
