import 'package:campaign_manager/features/campaigns/domain/entities/campaign_entity.dart';

abstract class CampaignRepository {
  Future<List<CampaignEntity>> getAllCampaigns();
  Future<List<CampaignEntity>> getCampaignsByStatus(CampaignStatusEnum status);
  Future<List<CampaignEntity>> getCampaignsByClientId(String clientId);
  Future<CampaignEntity?> getCampaignById(String id);
  Future<void> addCampaign(CampaignEntity campaign);
  Future<void> updateCampaign(CampaignEntity campaign);
  Future<void> deleteCampaign(String id);
  Future<int> getActiveCampaignsCount();
}
