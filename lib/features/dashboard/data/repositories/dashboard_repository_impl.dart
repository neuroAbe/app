import 'package:campaign_manager/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:campaign_manager/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:campaign_manager/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource _localDataSource;

  DashboardRepositoryImpl(this._localDataSource);

  @override
  Future<DashboardMetrics> getDashboardMetrics() async {
    return await _localDataSource.getDashboardMetrics();
  }

  @override
  Future<List<RecentActivity>> getRecentActivities() async {
    return await _localDataSource.getRecentActivities();
  }
}
