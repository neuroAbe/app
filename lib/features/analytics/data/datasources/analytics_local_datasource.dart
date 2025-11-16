import 'package:campaign_manager/features/analytics/data/models/metric_model.dart';
import 'package:campaign_manager/shared/services/database_service.dart';

abstract class AnalyticsLocalDataSource {
  Future<List<MetricModel>> getMetricsByCampaignId(String campaignId);
  Future<List<MetricModel>> getMetricsByDateRange(
    String campaignId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<MetricModel>> getAllRecentMetrics(int days);
  Future<Map<String, int>> getTotalMetrics();
  Future<void> insertMetric(MetricModel metric);
}

class AnalyticsLocalDataSourceImpl implements AnalyticsLocalDataSource {
  final DatabaseService _databaseService;

  AnalyticsLocalDataSourceImpl(this._databaseService);

  @override
  Future<List<MetricModel>> getMetricsByCampaignId(String campaignId) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'campaign_metrics',
      where: 'campaign_id = ?',
      whereArgs: [campaignId],
      orderBy: 'date ASC',
    );
    return maps.map((map) => MetricModel.fromMap(map)).toList();
  }

  @override
  Future<List<MetricModel>> getMetricsByDateRange(
    String campaignId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'campaign_metrics',
      where: 'campaign_id = ? AND date >= ? AND date <= ?',
      whereArgs: [
        campaignId,
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
      orderBy: 'date ASC',
    );
    return maps.map((map) => MetricModel.fromMap(map)).toList();
  }

  @override
  Future<List<MetricModel>> getAllRecentMetrics(int days) async {
    final db = await _databaseService.database;
    final startDate = DateTime.now()
        .subtract(Duration(days: days))
        .millisecondsSinceEpoch;
    final maps = await db.query(
      'campaign_metrics',
      where: 'date >= ?',
      whereArgs: [startDate],
      orderBy: 'date ASC',
    );
    return maps.map((map) => MetricModel.fromMap(map)).toList();
  }

  @override
  Future<Map<String, int>> getTotalMetrics() async {
    final db = await _databaseService.database;
    final result = await db.rawQuery('''
      SELECT
        SUM(impressions) as total_impressions,
        SUM(reach) as total_reach,
        SUM(engagement) as total_engagement,
        SUM(followers_gained) as total_followers,
        SUM(clicks) as total_clicks,
        SUM(shares) as total_shares,
        SUM(comments) as total_comments
      FROM campaign_metrics
    ''');

    if (result.isEmpty) {
      return {
        'total_impressions': 0,
        'total_reach': 0,
        'total_engagement': 0,
        'total_followers': 0,
        'total_clicks': 0,
        'total_shares': 0,
        'total_comments': 0,
      };
    }

    return {
      'total_impressions': (result.first['total_impressions'] as int?) ?? 0,
      'total_reach': (result.first['total_reach'] as int?) ?? 0,
      'total_engagement': (result.first['total_engagement'] as int?) ?? 0,
      'total_followers': (result.first['total_followers'] as int?) ?? 0,
      'total_clicks': (result.first['total_clicks'] as int?) ?? 0,
      'total_shares': (result.first['total_shares'] as int?) ?? 0,
      'total_comments': (result.first['total_comments'] as int?) ?? 0,
    };
  }

  @override
  Future<void> insertMetric(MetricModel metric) async {
    final db = await _databaseService.database;
    await db.insert('campaign_metrics', metric.toMap());
  }
}
