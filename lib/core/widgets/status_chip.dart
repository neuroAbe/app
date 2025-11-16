import 'package:flutter/material.dart';
import 'package:campaign_manager/core/constants/app_colors.dart';
import 'package:campaign_manager/core/constants/app_dimensions.dart';

enum CampaignStatus {
  draft,
  active,
  paused,
  completed,
}

class StatusChip extends StatelessWidget {
  final CampaignStatus status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: _getColor().withOpacity(0.3),
        ),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getColor(),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case CampaignStatus.draft:
        return AppColors.textSecondary;
      case CampaignStatus.active:
        return AppColors.success;
      case CampaignStatus.paused:
        return AppColors.warning;
      case CampaignStatus.completed:
        return AppColors.info;
    }
  }

  String _getLabel() {
    switch (status) {
      case CampaignStatus.draft:
        return 'Draft';
      case CampaignStatus.active:
        return 'Active';
      case CampaignStatus.paused:
        return 'Paused';
      case CampaignStatus.completed:
        return 'Completed';
    }
  }
}
