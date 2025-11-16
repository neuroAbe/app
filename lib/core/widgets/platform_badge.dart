import 'package:flutter/material.dart';
import 'package:campaign_manager/core/constants/app_colors.dart';
import 'package:campaign_manager/core/constants/app_dimensions.dart';

enum SocialPlatform {
  instagram,
  facebook,
  twitter,
  youtube,
  multi,
}

class PlatformBadge extends StatelessWidget {
  final SocialPlatform platform;
  final double size;
  final bool showLabel;

  const PlatformBadge({
    super.key,
    required this.platform,
    this.size = 24,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.xs),
          decoration: BoxDecoration(
            color: _getColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Icon(
            _getIcon(),
            color: _getColor(),
            size: size,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: AppDimensions.sm),
          Text(
            _getLabel(),
            style: TextStyle(
              color: _getColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Color _getColor() {
    switch (platform) {
      case SocialPlatform.instagram:
        return AppColors.instagram;
      case SocialPlatform.facebook:
        return AppColors.facebook;
      case SocialPlatform.twitter:
        return AppColors.twitter;
      case SocialPlatform.youtube:
        return AppColors.youtube;
      case SocialPlatform.multi:
        return AppColors.primary;
    }
  }

  IconData _getIcon() {
    switch (platform) {
      case SocialPlatform.instagram:
        return Icons.camera_alt;
      case SocialPlatform.facebook:
        return Icons.facebook;
      case SocialPlatform.twitter:
        return Icons.alternate_email;
      case SocialPlatform.youtube:
        return Icons.play_circle_fill;
      case SocialPlatform.multi:
        return Icons.dashboard;
    }
  }

  String _getLabel() {
    switch (platform) {
      case SocialPlatform.instagram:
        return 'Instagram';
      case SocialPlatform.facebook:
        return 'Facebook';
      case SocialPlatform.twitter:
        return 'Twitter';
      case SocialPlatform.youtube:
        return 'YouTube';
      case SocialPlatform.multi:
        return 'Multi-Platform';
    }
  }
}
