import 'package:campaign_manager/features/campaigns/domain/entities/campaign_entity.dart';

class CampaignModel extends CampaignEntity {
  const CampaignModel({
    required super.id,
    required super.clientId,
    required super.name,
    super.description,
    required super.status,
    required super.platform,
    required super.startDate,
    super.endDate,
    super.budget,
    super.targetReach,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CampaignModel.fromMap(Map<String, dynamic> map) {
    return CampaignModel(
      id: map['id'] as String,
      clientId: map['client_id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      status: _statusFromString(map['status'] as String),
      platform: _platformFromString(map['platform'] as String),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date'] as int),
      endDate: map['end_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['end_date'] as int)
          : null,
      budget: map['budget'] as double?,
      targetReach: map['target_reach'] as int?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': clientId,
      'name': name,
      'description': description,
      'status': _statusToString(status),
      'platform': _platformToString(platform),
      'start_date': startDate.millisecondsSinceEpoch,
      'end_date': endDate?.millisecondsSinceEpoch,
      'budget': budget,
      'target_reach': targetReach,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory CampaignModel.fromEntity(CampaignEntity entity) {
    return CampaignModel(
      id: entity.id,
      clientId: entity.clientId,
      name: entity.name,
      description: entity.description,
      status: entity.status,
      platform: entity.platform,
      startDate: entity.startDate,
      endDate: entity.endDate,
      budget: entity.budget,
      targetReach: entity.targetReach,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static CampaignStatusEnum _statusFromString(String status) {
    switch (status) {
      case 'draft':
        return CampaignStatusEnum.draft;
      case 'active':
        return CampaignStatusEnum.active;
      case 'paused':
        return CampaignStatusEnum.paused;
      case 'completed':
        return CampaignStatusEnum.completed;
      default:
        return CampaignStatusEnum.draft;
    }
  }

  static String _statusToString(CampaignStatusEnum status) {
    switch (status) {
      case CampaignStatusEnum.draft:
        return 'draft';
      case CampaignStatusEnum.active:
        return 'active';
      case CampaignStatusEnum.paused:
        return 'paused';
      case CampaignStatusEnum.completed:
        return 'completed';
    }
  }

  static PlatformEnum _platformFromString(String platform) {
    switch (platform) {
      case 'instagram':
        return PlatformEnum.instagram;
      case 'facebook':
        return PlatformEnum.facebook;
      case 'twitter':
        return PlatformEnum.twitter;
      case 'youtube':
        return PlatformEnum.youtube;
      case 'multi':
        return PlatformEnum.multi;
      default:
        return PlatformEnum.multi;
    }
  }

  static String _platformToString(PlatformEnum platform) {
    switch (platform) {
      case PlatformEnum.instagram:
        return 'instagram';
      case PlatformEnum.facebook:
        return 'facebook';
      case PlatformEnum.twitter:
        return 'twitter';
      case PlatformEnum.youtube:
        return 'youtube';
      case PlatformEnum.multi:
        return 'multi';
    }
  }
}
