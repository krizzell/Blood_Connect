import 'package:flutter/material.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/core/constants/app_constants.dart';
import 'package:gap/gap.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final Color? iconColor;
  final double? iconSize;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon,
    this.customIcon,
    this.onRetry,
    this.retryLabel,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            if (customIcon != null)
              customIcon!
            else if (icon != null)
              Icon(
                icon,
                size: iconSize ?? 64,
                color: iconColor ?? AppColors.textSecondary,
              ),

            const Gap(AppDimensions.spacing16),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            if (subtitle != null) ...[
              const Gap(AppDimensions.spacing8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],

            if (onRetry != null) ...[
              const Gap(AppDimensions.spacing24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(retryLabel ?? 'Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
