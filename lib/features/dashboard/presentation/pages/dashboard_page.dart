import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:campaign_manager/core/constants/app_colors.dart';
import 'package:campaign_manager/core/constants/app_dimensions.dart';
import 'package:campaign_manager/core/constants/app_strings.dart';
import 'package:campaign_manager/core/widgets/loading_indicator.dart';
import 'package:campaign_manager/core/widgets/error_view.dart';
import 'package:campaign_manager/core/widgets/metric_card.dart';
import 'package:campaign_manager/core/utils/extensions.dart';
import 'package:campaign_manager/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:campaign_manager/features/dashboard/domain/entities/dashboard_entity.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const LoadingIndicator();
            }

            if (state is DashboardError) {
              return ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<DashboardBloc>().add(LoadDashboard());
                },
              );
            }

            if (state is DashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(RefreshDashboard());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppDimensions.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: AppDimensions.xl),
                      _buildMetricsGrid(state.metrics),
                      const SizedBox(height: AppDimensions.xl),
                      _buildQuickStats(state.metrics),
                      const SizedBox(height: AppDimensions.xl),
                      _buildRecentActivity(state.recentActivities),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          now.formatted,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Widget _buildMetricsGrid(DashboardMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.todayOverview,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppDimensions.md,
          crossAxisSpacing: AppDimensions.md,
          childAspectRatio: 1.3,
          children: [
            MetricCard(
              title: AppStrings.activeClients,
              value: metrics.totalClients.toString(),
              icon: Icons.people,
              iconColor: AppColors.info,
            ),
            MetricCard(
              title: AppStrings.activeCampaigns,
              value: metrics.activeCampaigns.toString(),
              icon: Icons.campaign,
              iconColor: AppColors.success,
            ),
            MetricCard(
              title: AppStrings.pendingTasks,
              value: metrics.pendingTasks.toString(),
              icon: Icons.task_alt,
              iconColor: AppColors.warning,
            ),
            MetricCard(
              title: AppStrings.totalReach,
              value: metrics.totalReach.abbreviated,
              icon: Icons.visibility,
              iconColor: AppColors.secondary,
              trend: metrics.reachGrowth,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStats(DashboardMetrics metrics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Growth Trends',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            _buildTrendRow(
              'Reach Growth',
              metrics.reachGrowth,
              Icons.trending_up,
            ),
            const SizedBox(height: AppDimensions.md),
            _buildTrendRow(
              'Engagement Growth',
              metrics.engagementGrowth,
              Icons.favorite,
            ),
            const SizedBox(height: AppDimensions.md),
            _buildTrendRow(
              'Followers Growth',
              metrics.followersGrowth,
              Icons.person_add,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendRow(String label, double value, IconData icon) {
    final isPositive = value >= 0;
    return Row(
      children: [
        Icon(
          icon,
          size: AppDimensions.iconSm,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.sm,
            vertical: AppDimensions.xs,
          ),
          decoration: BoxDecoration(
            color: (isPositive ? AppColors.success : AppColors.error)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: isPositive ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 2),
              Text(
                '${value.abs().toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(List<RecentActivity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.recentActivity,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityTile(activity);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTile(RecentActivity activity) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppDimensions.sm),
        decoration: BoxDecoration(
          color: _getActivityColor(activity.type).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: Icon(
          _getActivityIcon(activity.type),
          color: _getActivityColor(activity.type),
          size: AppDimensions.iconSm,
        ),
      ),
      title: Text(
        activity.title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        activity.subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Text(
        activity.timestamp.relativeDate,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.campaignCreated:
        return Icons.add_circle;
      case ActivityType.campaignCompleted:
        return Icons.check_circle;
      case ActivityType.taskCompleted:
        return Icons.task_alt;
      case ActivityType.clientAdded:
        return Icons.person_add;
      case ActivityType.postScheduled:
        return Icons.schedule;
      case ActivityType.metricsUpdated:
        return Icons.analytics;
    }
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.campaignCreated:
        return AppColors.info;
      case ActivityType.campaignCompleted:
        return AppColors.success;
      case ActivityType.taskCompleted:
        return AppColors.success;
      case ActivityType.clientAdded:
        return AppColors.secondary;
      case ActivityType.postScheduled:
        return AppColors.warning;
      case ActivityType.metricsUpdated:
        return AppColors.primary;
    }
  }
}
