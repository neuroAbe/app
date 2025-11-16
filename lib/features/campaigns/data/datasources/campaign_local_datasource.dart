import 'package:campaign_manager/features/campaigns/data/models/campaign_model.dart';
import 'package:campaign_manager/shared/services/database_service.dart';

abstract class CampaignLocalDataSource {
  Future<List<CampaignModel>> getAllCampaigns();
  Future<List<CampaignModel>> getCampaignsByStatus(String status);
  Future<List<CampaignModel>> getCampaignsByClientId(String clientId);
  Future<CampaignModel?> getCampaignById(String id);
  Future<void> insertCampaign(CampaignModel campaign);
  Future<void> updateCampaign(CampaignModel campaign);
  Future<void> deleteCampaign(String id);
  Future<int> getActiveCampaignsCount();
}

class CampaignLocalDataSourceImpl implements CampaignLocalDataSource {
  final DatabaseService _databaseService;

  CampaignLocalDataSourceImpl(this._databaseService);

  @override
  Future<List<CampaignModel>> getAllCampaigns() async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'campaigns',
      orderBy: 'updated_at DESC',
    );
    return maps.map((map) => CampaignModel.fromMap(map)).toList();
  }

  @override
  Future<List<CampaignModel>> getCampaignsByStatus(String status) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'campaigns',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'updated_at DESC',
    );
    return maps.map((map) => CampaignModel.fromMap(map)).toList();
  }

  @override
  Future<List<CampaignModel>> getCampaignsByClientId(String clientId) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'campaigns',
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'start_date DESC',
    );
    return maps.map((map) => CampaignModel.fromMap(map)).toList();
  }

  @override
  Future<CampaignModel?> getCampaignById(String id) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'campaigns',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return CampaignModel.fromMap(maps.first);
  }

  @override
  Future<void> insertCampaign(CampaignModel campaign) async {
    final db = await _databaseService.database;
    await db.insert('campaigns', campaign.toMap());
  }

  @override
  Future<void> updateCampaign(CampaignModel campaign) async {
    final db = await _databaseService.database;
    await db.update(
      'campaigns',
      campaign.toMap(),
      where: 'id = ?',
      whereArgs: [campaign.id],
    );
  }

  @override
  Future<void> deleteCampaign(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'campaigns',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> getActiveCampaignsCount() async {
    final db = await _databaseService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM campaigns WHERE status = ?',
      ['active'],
    );
    return result.first['count'] as int;
  }
}
