import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:campaign_manager/core/constants/app_colors.dart';
import 'package:campaign_manager/core/constants/app_dimensions.dart';
import 'package:campaign_manager/core/constants/app_strings.dart';
import 'package:campaign_manager/core/widgets/loading_indicator.dart';
import 'package:campaign_manager/core/widgets/error_view.dart';
import 'package:campaign_manager/core/widgets/empty_state.dart';
import 'package:campaign_manager/core/widgets/status_chip.dart';
import 'package:campaign_manager/core/widgets/platform_badge.dart';
import 'package:campaign_manager/core/utils/extensions.dart';
import 'package:campaign_manager/features/campaigns/presentation/bloc/campaign_bloc.dart';
import 'package:campaign_manager/features/campaigns/domain/entities/campaign_entity.dart';

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({super.key});

  @override
  State<CampaignsPage> createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<CampaignBloc>().add(LoadCampaigns());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.campaigns),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Draft'),
            Tab(text: 'Completed'),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                context.read<CampaignBloc>().add(LoadCampaigns());
                break;
              case 1:
                context.read<CampaignBloc>().add(
                      const LoadCampaignsByStatus(CampaignStatusEnum.active),
                    );
                break;
              case 2:
                context.read<CampaignBloc>().add(
                      const LoadCampaignsByStatus(CampaignStatusEnum.draft),
                    );
                break;
              case 3:
                context.read<CampaignBloc>().add(
                      const LoadCampaignsByStatus(CampaignStatusEnum.completed),
                    );
                break;
            }
          },
        ),
      ),
      body: BlocBuilder<CampaignBloc, CampaignState>(
        builder: (context, state) {
          if (state is CampaignLoading) {
            return const LoadingIndicator();
          }

          if (state is CampaignError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<CampaignBloc>().add(LoadCampaigns());
              },
            );
          }

          if (state is CampaignsLoaded) {
            if (state.campaigns.isEmpty) {
              return EmptyState(
                icon: Icons.campaign_outlined,
                title: 'No Campaigns Found',
                subtitle: 'Create your first campaign to get started',
                action: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to create campaign
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(AppStrings.newCampaign),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CampaignBloc>().add(LoadCampaigns());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                itemCount: state.campaigns.length,
                itemBuilder: (context, index) {
                  final campaign = state.campaigns[index];
                  return _buildCampaignCard(campaign);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create campaign
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCampaignCard(CampaignEntity campaign) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to campaign details
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      campaign.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  StatusChip(status: _mapStatus(campaign.status)),
                ],
              ),
              if (campaign.description != null) ...[
                const SizedBox(height: AppDimensions.sm),
                Text(
                  campaign.description!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppDimensions.md),
              Row(
                children: [
                  PlatformBadge(
                    platform: _mapPlatform(campaign.platform),
                    showLabel: true,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    campaign.startDate.formatted,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              if (campaign.budget != null || campaign.targetReach != null) ...[
                const SizedBox(height: AppDimensions.md),
                const Divider(),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    if (campaign.budget != null) ...[
                      Icon(
                        Icons.attach_money,
                        size: 16,
                        color: AppColors.success,
                      ),
                      Text(
                        campaign.budget!.currency,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.lg),
                    ],
                    if (campaign.targetReach != null) ...[
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: AppDimensions.xs),
                      Text(
                        '${campaign.targetReach!.abbreviated} reach',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  CampaignStatus _mapStatus(CampaignStatusEnum status) {
    switch (status) {
      case CampaignStatusEnum.draft:
        return CampaignStatus.draft;
      case CampaignStatusEnum.active:
        return CampaignStatus.active;
      case CampaignStatusEnum.paused:
        return CampaignStatus.paused;
      case CampaignStatusEnum.completed:
        return CampaignStatus.completed;
    }
  }

  SocialPlatform _mapPlatform(PlatformEnum platform) {
    switch (platform) {
      case PlatformEnum.instagram:
        return SocialPlatform.instagram;
      case PlatformEnum.facebook:
        return SocialPlatform.facebook;
      case PlatformEnum.twitter:
        return SocialPlatform.twitter;
      case PlatformEnum.youtube:
        return SocialPlatform.youtube;
      case PlatformEnum.multi:
        return SocialPlatform.multi;
    }
  }
}
