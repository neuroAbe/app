import 'package:campaign_manager/features/analytics/domain/entities/metric_entity.dart';

abstract class AnalyticsRepository {
  Future<List<MetricEntity>> getMetricsByCampaignId(String campaignId);
  Future<List<MetricEntity>> getMetricsByDateRange(
    String campaignId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<MetricEntity>> getAllRecentMetrics(int days);
  Future<AggregatedMetrics> getAggregatedMetrics();
}
