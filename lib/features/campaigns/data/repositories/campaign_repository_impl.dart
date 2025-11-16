import 'package:campaign_manager/features/campaigns/data/datasources/campaign_local_datasource.dart';
import 'package:campaign_manager/features/campaigns/data/models/campaign_model.dart';
import 'package:campaign_manager/features/campaigns/domain/entities/campaign_entity.dart';
import 'package:campaign_manager/features/campaigns/domain/repositories/campaign_repository.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  final CampaignLocalDataSource _localDataSource;

  CampaignRepositoryImpl(this._localDataSource);

  @override
  Future<List<CampaignEntity>> getAllCampaigns() async {
    return await _localDataSource.getAllCampaigns();
  }

  @override
  Future<List<CampaignEntity>> getCampaignsByStatus(
    CampaignStatusEnum status,
  ) async {
    final statusString = _statusToString(status);
    return await _localDataSource.getCampaignsByStatus(statusString);
  }

  @override
  Future<List<CampaignEntity>> getCampaignsByClientId(String clientId) async {
    return await _localDataSource.getCampaignsByClientId(clientId);
  }

  @override
  Future<CampaignEntity?> getCampaignById(String id) async {
    return await _localDataSource.getCampaignById(id);
  }

  @override
  Future<void> addCampaign(CampaignEntity campaign) async {
    final model = CampaignModel.fromEntity(campaign);
    await _localDataSource.insertCampaign(model);
  }

  @override
  Future<void> updateCampaign(CampaignEntity campaign) async {
    final model = CampaignModel.fromEntity(campaign);
    await _localDataSource.updateCampaign(model);
  }

  @override
  Future<void> deleteCampaign(String id) async {
    await _localDataSource.deleteCampaign(id);
  }

  @override
  Future<int> getActiveCampaignsCount() async {
    return await _localDataSource.getActiveCampaignsCount();
  }

  String _statusToString(CampaignStatusEnum status) {
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
}
