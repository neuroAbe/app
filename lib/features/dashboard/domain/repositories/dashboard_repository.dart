import 'package:campaign_manager/features/dashboard/domain/entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<DashboardMetrics> getDashboardMetrics();
  Future<List<RecentActivity>> getRecentActivities();
}
