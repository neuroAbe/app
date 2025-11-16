import 'package:campaign_manager/features/clients/domain/entities/client_entity.dart';

class ClientModel extends ClientEntity {
  const ClientModel({
    required super.id,
    required super.name,
    required super.company,
    super.email,
    super.phone,
    super.instagramHandle,
    super.facebookPage,
    super.twitterHandle,
    super.youtubeChannel,
    super.logoUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] as String,
      name: map['name'] as String,
      company: map['company'] as String,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      instagramHandle: map['instagram_handle'] as String?,
      facebookPage: map['facebook_page'] as String?,
      twitterHandle: map['twitter_handle'] as String?,
      youtubeChannel: map['youtube_channel'] as String?,
      logoUrl: map['logo_url'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'email': email,
      'phone': phone,
      'instagram_handle': instagramHandle,
      'facebook_page': facebookPage,
      'twitter_handle': twitterHandle,
      'youtube_channel': youtubeChannel,
      'logo_url': logoUrl,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ClientModel.fromEntity(ClientEntity entity) {
    return ClientModel(
      id: entity.id,
      name: entity.name,
      company: entity.company,
      email: entity.email,
      phone: entity.phone,
      instagramHandle: entity.instagramHandle,
      facebookPage: entity.facebookPage,
      twitterHandle: entity.twitterHandle,
      youtubeChannel: entity.youtubeChannel,
      logoUrl: entity.logoUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
