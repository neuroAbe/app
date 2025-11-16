import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  final String id;
  final String name;
  final String company;
  final String? email;
  final String? phone;
  final String? instagramHandle;
  final String? facebookPage;
  final String? twitterHandle;
  final String? youtubeChannel;
  final String? logoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClientEntity({
    required this.id,
    required this.name,
    required this.company,
    this.email,
    this.phone,
    this.instagramHandle,
    this.facebookPage,
    this.twitterHandle,
    this.youtubeChannel,
    this.logoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        company,
        email,
        phone,
        instagramHandle,
        facebookPage,
        twitterHandle,
        youtubeChannel,
        logoUrl,
        createdAt,
        updatedAt,
      ];

  ClientEntity copyWith({
    String? id,
    String? name,
    String? company,
    String? email,
    String? phone,
    String? instagramHandle,
    String? facebookPage,
    String? twitterHandle,
    String? youtubeChannel,
    String? logoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      facebookPage: facebookPage ?? this.facebookPage,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      youtubeChannel: youtubeChannel ?? this.youtubeChannel,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
