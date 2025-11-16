import 'package:campaign_manager/shared/services/database_service.dart';
import 'package:campaign_manager/features/dashboard/domain/entities/dashboard_entity.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardMetrics> getDashboardMetrics();
  Future<List<RecentActivity>> getRecentActivities();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final DatabaseService _databaseService;

  DashboardLocalDataSourceImpl(this._databaseService);

  @override
  Future<DashboardMetrics> getDashboardMetrics() async {
    final db = await _databaseService.database;

    // Get total clients count
    final clientsResult = await db.rawQuery('SELECT COUNT(*) as count FROM clients');
    final totalClients = clientsResult.first['count'] as int;

    // Get active campaigns count
    final campaignsResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM campaigns WHERE status = ?',
      ['active'],
    );
    final activeCampaigns = campaignsResult.first['count'] as int;

    // Get pending tasks count
    final tasksResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE is_completed = ?',
      [0],
    );
    final pendingTasks = tasksResult.first['count'] as int;

    // Get total reach from all metrics
    final reachResult = await db.rawQuery(
      'SELECT SUM(reach) as total_reach FROM campaign_metrics',
    );
    final totalReach = (reachResult.first['total_reach'] as int?) ?? 0;

    // Calculate growth percentages (comparing last 7 days to previous 7 days)
    final now = DateTime.now().millisecondsSinceEpoch;
    final sevenDaysAgo = DateTime.now()
        .subtract(const Duration(days: 7))
        .millisecondsSinceEpoch;
    final fourteenDaysAgo = DateTime.now()
        .subtract(const Duration(days: 14))
        .millisecondsSinceEpoch;

    // Recent period metrics
    final recentMetrics = await db.rawQuery('''
      SELECT
        SUM(reach) as reach,
        SUM(engagement) as engagement,
        SUM(followers_gained) as followers
      FROM campaign_metrics
      WHERE date >= ? AND date < ?
    ''', [sevenDaysAgo, now]);

    // Previous period metrics
    final previousMetrics = await db.rawQuery('''
      SELECT
        SUM(reach) as reach,
        SUM(engagement) as engagement,
        SUM(followers_gained) as followers
      FROM campaign_metrics
      WHERE date >= ? AND date < ?
    ''', [fourteenDaysAgo, sevenDaysAgo]);

    final recentReach = (recentMetrics.first['reach'] as int?) ?? 0;
    final previousReach = (previousMetrics.first['reach'] as int?) ?? 1;
    final reachGrowth = ((recentReach - previousReach) / previousReach) * 100;

    final recentEngagement = (recentMetrics.first['engagement'] as int?) ?? 0;
    final previousEngagement = (previousMetrics.first['engagement'] as int?) ?? 1;
    final engagementGrowth =
        ((recentEngagement - previousEngagement) / previousEngagement) * 100;

    final recentFollowers = (recentMetrics.first['followers'] as int?) ?? 0;
    final previousFollowers = (previousMetrics.first['followers'] as int?) ?? 1;
    final followersGrowth =
        ((recentFollowers - previousFollowers) / previousFollowers) * 100;

    return DashboardMetrics(
      totalClients: totalClients,
      activeCampaigns: activeCampaigns,
      pendingTasks: pendingTasks,
      totalReach: totalReach,
      reachGrowth: reachGrowth,
      engagementGrowth: engagementGrowth,
      followersGrowth: followersGrowth,
    );
  }

  @override
  Future<List<RecentActivity>> getRecentActivities() async {
    final db = await _databaseService.database;
    final activities = <RecentActivity>[];

    // Get recent campaigns
    final campaigns = await db.query(
      'campaigns',
      orderBy: 'created_at DESC',
      limit: 3,
    );

    for (final campaign in campaigns) {
      final status = campaign['status'] as String;
      activities.add(
        RecentActivity(
          id: campaign['id'] as String,
          title: status == 'completed'
              ? 'Campaign Completed'
              : 'Campaign Created',
          subtitle: campaign['name'] as String,
          type: status == 'completed'
              ? ActivityType.campaignCompleted
              : ActivityType.campaignCreated,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            campaign['created_at'] as int,
          ),
        ),
      );
    }

    // Get recent completed tasks
    final tasks = await db.query(
      'tasks',
      where: 'is_completed = ?',
      whereArgs: [1],
      orderBy: 'completed_at DESC',
      limit: 2,
    );

    for (final task in tasks) {
      activities.add(
        RecentActivity(
          id: task['id'] as String,
          title: 'Task Completed',
          subtitle: task['title'] as String,
          type: ActivityType.taskCompleted,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            (task['completed_at'] as int?) ?? task['created_at'] as int,
          ),
        ),
      );
    }

    // Get recent clients
    final clients = await db.query(
      'clients',
      orderBy: 'created_at DESC',
      limit: 2,
    );

    for (final client in clients) {
      activities.add(
        RecentActivity(
          id: client['id'] as String,
          title: 'Client Added',
          subtitle: client['company'] as String,
          type: ActivityType.clientAdded,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            client['created_at'] as int,
          ),
        ),
      );
    }

    // Sort all activities by timestamp
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return activities.take(5).toList();
  }
}
