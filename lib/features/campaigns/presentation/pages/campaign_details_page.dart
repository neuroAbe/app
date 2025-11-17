import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:campaign_manager/core/constants/app_colors.dart';
import 'package:campaign_manager/core/constants/app_dimensions.dart';
import 'package:campaign_manager/core/widgets/loading_indicator.dart';
import 'package:campaign_manager/core/widgets/error_view.dart';
import 'package:campaign_manager/core/widgets/status_chip.dart';
import 'package:campaign_manager/core/widgets/platform_badge.dart';
import 'package:campaign_manager/core/utils/extensions.dart';
import 'package:campaign_manager/features/campaigns/presentation/bloc/campaign_bloc.dart';
import 'package:campaign_manager/features/campaigns/domain/entities/campaign_entity.dart';
import 'package:campaign_manager/features/analytics/presentation/bloc/analytics_bloc.dart';

class CampaignDetailsPage extends StatefulWidget {
  final String campaignId;
  final CampaignEntity? campaign;

  const CampaignDetailsPage({
    super.key,
    required this.campaignId,
    this.campaign,
  });

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.campaign == null) {
      context.read<CampaignBloc>().add(LoadCampaignDetails(widget.campaignId));
    }
    context.read<AnalyticsBloc>().add(LoadCampaignAnalytics(widget.campaignId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Campaign Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit campaign
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Campaign'),
              ),
            ],
          ),
        ],
      ),
      body: widget.campaign != null
          ? _buildContent(widget.campaign!)
          : BlocBuilder<CampaignBloc, CampaignState>(
              builder: (context, state) {
                if (state is CampaignLoading) {
                  return const LoadingIndicator();
                }
                if (state is CampaignError) {
                  return ErrorView(message: state.message);
                }
                if (state is CampaignDetailsLoaded) {
                  return _buildContent(state.campaign);
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }

  Widget _buildContent(CampaignEntity campaign) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(campaign),
          const SizedBox(height: AppDimensions.xl),
          _buildMetricsSection(),
          const SizedBox(height: AppDimensions.xl),
          _buildDetailsCard(campaign),
          const SizedBox(height: AppDimensions.xl),
          _buildPerformanceChart(),
        ],
      ),
    );
  }

  Widget _buildHeader(CampaignEntity campaign) {
    return Card(
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                StatusChip(status: _mapStatus(campaign.status)),
              ],
            ),
            if (campaign.description != null) ...[
              const SizedBox(height: AppDimensions.md),
              Text(
                campaign.description!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.lg),
            Row(
              children: [
                PlatformBadge(
                  platform: _mapPlatform(campaign.platform),
                  showLabel: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSection() {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is CampaignAnalyticsLoaded) {
          int totalReach = 0;
          int totalEngagement = 0;
          int totalClicks = 0;

          for (final metric in state.metrics) {
            totalReach += metric.reach;
            totalEngagement += metric.engagement;
            totalClicks += metric.clicks;
          }

          return Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Reach',
                  totalReach.abbreviated,
                  Icons.visibility,
                  AppColors.info,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: _buildMetricCard(
                  'Engagement',
                  totalEngagement.abbreviated,
                  Icons.favorite,
                  AppColors.error,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: _buildMetricCard(
                  'Clicks',
                  totalClicks.abbreviated,
                  Icons.touch_app,
                  AppColors.success,
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppDimensions.xs),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(CampaignEntity campaign) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Campaign Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            _buildDetailRow('Start Date', campaign.startDate.formatted),
            if (campaign.endDate != null)
              _buildDetailRow('End Date', campaign.endDate!.formatted),
            if (campaign.budget != null)
              _buildDetailRow('Budget', campaign.budget!.currency),
            if (campaign.targetReach != null)
              _buildDetailRow(
                'Target Reach',
                campaign.targetReach!.withCommas,
              ),
            _buildDetailRow('Created', campaign.createdAt.formatted),
            _buildDetailRow('Last Updated', campaign.updatedAt.formatted),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is CampaignAnalyticsLoaded && state.metrics.isNotEmpty) {
          final spots = <FlSpot>[];
          for (int i = 0; i < state.metrics.length; i++) {
            spots.add(FlSpot(
              i.toDouble(),
              state.metrics[i].engagement.toDouble(),
            ));
          }

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Engagement Over Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: const FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.primary.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Campaign'),
        content: const Text(
          'Are you sure you want to delete this campaign? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CampaignBloc>().add(DeleteCampaign(widget.campaignId));
              Navigator.pop(this.context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
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
