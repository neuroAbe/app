import 'package:campaign_manager/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:campaign_manager/features/analytics/domain/entities/metric_entity.dart';
import 'package:campaign_manager/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsLocalDataSource _localDataSource;

  AnalyticsRepositoryImpl(this._localDataSource);

  @override
  Future<List<MetricEntity>> getMetricsByCampaignId(String campaignId) async {
    return await _localDataSource.getMetricsByCampaignId(campaignId);
  }

  @override
  Future<List<MetricEntity>> getMetricsByDateRange(
    String campaignId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _localDataSource.getMetricsByDateRange(
      campaignId,
      startDate,
      endDate,
    );
  }

  @override
  Future<List<MetricEntity>> getAllRecentMetrics(int days) async {
    return await _localDataSource.getAllRecentMetrics(days);
  }

  @override
  Future<AggregatedMetrics> getAggregatedMetrics() async {
    final totals = await _localDataSource.getTotalMetrics();
    final metrics = await _localDataSource.getAllRecentMetrics(30);

    double avgEngagementRate = 0;
    double avgClickThroughRate = 0;

    if (metrics.isNotEmpty) {
      double totalEngagementRate = 0;
      double totalClickThroughRate = 0;

      for (final metric in metrics) {
        totalEngagementRate += metric.engagementRate;
        totalClickThroughRate += metric.clickThroughRate;
      }

      avgEngagementRate = totalEngagementRate / metrics.length;
      avgClickThroughRate = totalClickThroughRate / metrics.length;
    }

    return AggregatedMetrics(
      totalImpressions: totals['total_impressions']!,
      totalReach: totals['total_reach']!,
      totalEngagement: totals['total_engagement']!,
      totalFollowersGained: totals['total_followers']!,
      totalClicks: totals['total_clicks']!,
      totalShares: totals['total_shares']!,
      totalComments: totals['total_comments']!,
      avgEngagementRate: avgEngagementRate,
      avgClickThroughRate: avgClickThroughRate,
    );
  }
}
