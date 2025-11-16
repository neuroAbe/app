import 'package:campaign_manager/features/analytics/domain/entities/metric_entity.dart';

class MetricModel extends MetricEntity {
  const MetricModel({
    required super.id,
    required super.campaignId,
    required super.date,
    required super.impressions,
    required super.reach,
    required super.engagement,
    required super.followersGained,
    required super.clicks,
    required super.shares,
    required super.comments,
  });

  factory MetricModel.fromMap(Map<String, dynamic> map) {
    return MetricModel(
      id: map['id'] as String,
      campaignId: map['campaign_id'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      impressions: map['impressions'] as int,
      reach: map['reach'] as int,
      engagement: map['engagement'] as int,
      followersGained: map['followers_gained'] as int,
      clicks: map['clicks'] as int,
      shares: map['shares'] as int,
      comments: map['comments'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'campaign_id': campaignId,
      'date': date.millisecondsSinceEpoch,
      'impressions': impressions,
      'reach': reach,
      'engagement': engagement,
      'followers_gained': followersGained,
      'clicks': clicks,
      'shares': shares,
      'comments': comments,
    };
  }

  factory MetricModel.fromEntity(MetricEntity entity) {
    return MetricModel(
      id: entity.id,
      campaignId: entity.campaignId,
      date: entity.date,
      impressions: entity.impressions,
      reach: entity.reach,
      engagement: entity.engagement,
      followersGained: entity.followersGained,
      clicks: entity.clicks,
      shares: entity.shares,
      comments: entity.comments,
    );
  }
}
