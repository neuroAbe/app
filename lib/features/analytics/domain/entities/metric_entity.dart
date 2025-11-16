import 'package:equatable/equatable.dart';

class MetricEntity extends Equatable {
  final String id;
  final String campaignId;
  final DateTime date;
  final int impressions;
  final int reach;
  final int engagement;
  final int followersGained;
  final int clicks;
  final int shares;
  final int comments;

  const MetricEntity({
    required this.id,
    required this.campaignId,
    required this.date,
    required this.impressions,
    required this.reach,
    required this.engagement,
    required this.followersGained,
    required this.clicks,
    required this.shares,
    required this.comments,
  });

  @override
  List<Object?> get props => [
        id,
        campaignId,
        date,
        impressions,
        reach,
        engagement,
        followersGained,
        clicks,
        shares,
        comments,
      ];

  double get engagementRate {
    if (reach == 0) return 0;
    return (engagement / reach) * 100;
  }

  double get clickThroughRate {
    if (impressions == 0) return 0;
    return (clicks / impressions) * 100;
  }
}

class AggregatedMetrics extends Equatable {
  final int totalImpressions;
  final int totalReach;
  final int totalEngagement;
  final int totalFollowersGained;
  final int totalClicks;
  final int totalShares;
  final int totalComments;
  final double avgEngagementRate;
  final double avgClickThroughRate;

  const AggregatedMetrics({
    required this.totalImpressions,
    required this.totalReach,
    required this.totalEngagement,
    required this.totalFollowersGained,
    required this.totalClicks,
    required this.totalShares,
    required this.totalComments,
    required this.avgEngagementRate,
    required this.avgClickThroughRate,
  });

  @override
  List<Object?> get props => [
        totalImpressions,
        totalReach,
        totalEngagement,
        totalFollowersGained,
        totalClicks,
        totalShares,
        totalComments,
        avgEngagementRate,
        avgClickThroughRate,
      ];
}
