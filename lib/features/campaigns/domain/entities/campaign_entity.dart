import 'package:equatable/equatable.dart';

enum CampaignStatusEnum {
  draft,
  active,
  paused,
  completed,
}

enum PlatformEnum {
  instagram,
  facebook,
  twitter,
  youtube,
  multi,
}

class CampaignEntity extends Equatable {
  final String id;
  final String clientId;
  final String name;
  final String? description;
  final CampaignStatusEnum status;
  final PlatformEnum platform;
  final DateTime startDate;
  final DateTime? endDate;
  final double? budget;
  final int? targetReach;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CampaignEntity({
    required this.id,
    required this.clientId,
    required this.name,
    this.description,
    required this.status,
    required this.platform,
    required this.startDate,
    this.endDate,
    this.budget,
    this.targetReach,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        clientId,
        name,
        description,
        status,
        platform,
        startDate,
        endDate,
        budget,
        targetReach,
        createdAt,
        updatedAt,
      ];

  CampaignEntity copyWith({
    String? id,
    String? clientId,
    String? name,
    String? description,
    CampaignStatusEnum? status,
    PlatformEnum? platform,
    DateTime? startDate,
    DateTime? endDate,
    double? budget,
    int? targetReach,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampaignEntity(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      platform: platform ?? this.platform,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budget: budget ?? this.budget,
      targetReach: targetReach ?? this.targetReach,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
