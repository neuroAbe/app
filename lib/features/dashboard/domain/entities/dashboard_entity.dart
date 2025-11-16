import 'package:equatable/equatable.dart';

class DashboardMetrics extends Equatable {
  final int totalClients;
  final int activeCampaigns;
  final int pendingTasks;
  final int totalReach;
  final double reachGrowth;
  final double engagementGrowth;
  final double followersGrowth;

  const DashboardMetrics({
    required this.totalClients,
    required this.activeCampaigns,
    required this.pendingTasks,
    required this.totalReach,
    required this.reachGrowth,
    required this.engagementGrowth,
    required this.followersGrowth,
  });

  @override
  List<Object?> get props => [
        totalClients,
        activeCampaigns,
        pendingTasks,
        totalReach,
        reachGrowth,
        engagementGrowth,
        followersGrowth,
      ];
}

class RecentActivity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final ActivityType type;
  final DateTime timestamp;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, title, subtitle, type, timestamp];
}

enum ActivityType {
  campaignCreated,
  campaignCompleted,
  taskCompleted,
  clientAdded,
  postScheduled,
  metricsUpdated,
}
